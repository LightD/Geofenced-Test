//
//  Geofence.swift
//  Geofenced-Test
//
//  Created by Nour on 2/22/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import Foundation
import CoreLocation

struct Geofence: Codable {
    let lat: Double
    let long: Double
    let radius: Double
    let networkName: String?
    
    init(lat: Double, long: Double, radius: Double, networkName: String? = nil) {
        self.lat = lat
        self.long = long
        self.radius = radius
        self.networkName = networkName
    }
}

extension Geofence {
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
    
    var circularRegion: CLCircularRegion {
        return CLCircularRegion(center: self.coordinates, radius: self.radius, identifier: "myOnlyGeofence")
    }
    
    func update(radius: Double) -> Geofence {
        return Geofence(lat: self.lat, long: self.long, radius: radius, networkName: self.networkName)
    }
    
    func update(coords: CLLocationCoordinate2D) -> Geofence {
        return Geofence(lat: coords.latitude, long: coords.longitude, radius: self.radius, networkName: self.networkName)
    }
    
    func update(network: String?) -> Geofence {
        return Geofence(lat: self.lat, long: self.long, radius: self.radius, networkName: network)
    }
    
    static var `default`: Geofence {
        return Geofence(lat: 3.1466, long: 101.6958, radius: 1000)
    }
}
