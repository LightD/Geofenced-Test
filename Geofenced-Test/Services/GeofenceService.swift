//
//  GeofenceService.swift
//  Geofenced-Test
//
//  Created by Nour on 2/22/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCoreLocation

protocol GeofenceServiceType: Service {
    func update(geofence: Geofence)
    var isInsideGeofence: Observable<Bool> { get }
}

final class GeofenceService: GeofenceServiceType, HasDisposeBag {
    
    private let locationManager: CLLocationManager
    private let networkManager: RxWifi
    
    private let lastKnownGeofenceSubject: BehaviorSubject<Geofence?> = BehaviorSubject(value: nil)
    private let isInsideGeofenceSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var isInsideGeofence: Observable<Bool> { return isInsideGeofenceSubject.asObservable().share(replay: 1, scope: .whileConnected) }
    
    init(locationManager: CLLocationManager, networkManager: RxWifi = RxWifi.shared) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        self.setup()
        self.observeData()
    }
    
    private func setup() {
        // read the Geofence and un-archive it
        self.lastKnownGeofenceSubject.onNext(self.decode())
    }
    
    private func decode() -> Geofence? {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "geofence"),
            let geofence = try? decoder.decode(Geofence.self, from: data) {
            return geofence
        }
        return nil
    }
    
    private func encode(geofence: Geofence) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(geofence) {
            UserDefaults.standard.set(encoded, forKey: "geofence")
        }
    }
    
    private func observeData() {
        // check if network is the same as geofence
        let isSameNetworkObservable = Observable
            .combineLatest(self.networkManager.rx.ssidChanged, self.lastKnownGeofenceSubject.map { $0?.networkName })
            .map { (data: (ssid: String?, existing: String?)) -> Bool in
                return data.ssid != nil && data.existing != nil && data.ssid == data.existing
            }
        
        let isInsideRegion = Observable
            .combineLatest(self.locationManager.rx.location.map { $0?.coordinate }, self.lastKnownGeofenceSubject.map { $0?.circularRegion })
            .map { (data: (coords: CLLocationCoordinate2D?, region: CLCircularRegion?)) -> Bool in
                guard let region = data.region, let coords = data.coords else { return false }
                return region.contains(coords)
            }
        
        Observable.combineLatest(isSameNetworkObservable, isInsideRegion)
            .map { (data: (network: Bool, region: Bool)) -> Bool in
                // in case network is the same, always consider inside.
                return data.network == true ? data.network : data.region
            }
            .bind(to: self.isInsideGeofenceSubject)
            .disposed(by: self.disposeBag)
    }
    
    func update(geofence: Geofence) {
        self.encode(geofence: geofence)
        self.lastKnownGeofenceSubject.onNext(geofence)
    }
}
