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
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
    
    var circularRegion: CLCircularRegion {
        return CLCircularRegion(center: self.coordinates, radius: self.radius, identifier: "myOnlyGeofence")
    }
}
