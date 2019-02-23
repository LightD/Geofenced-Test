//
//  HomeViewModel.swift
//  Geofenced-Test
//
//  Created by Nour on 2/22/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol HomeViewModelInputs {
    func update(coords: CLLocationCoordinate2D)
    func update(radius: String)
    func update(network: String?)
}

protocol HomeViewModelOutputs {
    var status: Driver<String?> { get }
    var statusColor: Driver<UIColor> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

final class HomeViewModel: HomeViewModelInputs, HomeViewModelOutputs, HomeViewModelType, HasDisposeBag {
    
    var status: Driver<String?> { return statusRelay.asDriver() }
    var statusColor: Driver<UIColor> { return statusColorRelay.asDriver() }
    
    private let geofenceRelay = BehaviorRelay<Geofence>(value: Geofence.default)
    private let statusRelay = BehaviorRelay<String?>(value: "Outside")
    private let statusColorRelay = BehaviorRelay<UIColor>(value: .red)
    
    private let geoService: GeofenceServiceType
    init(geoService: GeofenceServiceType) {
        self.geoService = geoService
        self.bind()
    }
    
    private func bind() {
        self.geoService.isInsideGeofence
            .map { $0 ? "Inside" : "Outside" }
            .bind(to: self.statusRelay)
            .disposed(by: self.disposeBag)
        
        self.geoService.isInsideGeofence
            .map { $0 ? .green : .red }
            .bind(to: self.statusColorRelay)
            .disposed(by: self.disposeBag)
    }
    
    func update(coords: CLLocationCoordinate2D) {
        self.geoService.update(geofence: self.geofenceRelay.value.update(coords: coords))
    }
    
    func update(radius: String) {
        self.geoService.update(geofence: self.geofenceRelay.value.update(radius: Double(radius) ?? 0))
    }
    
    func update(network: String?) {
        self.geoService.update(geofence: self.geofenceRelay.value.update(network: network))
    }
    
    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
}
