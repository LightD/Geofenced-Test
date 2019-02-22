//
//  ServicesAssembly.swift
//  Geofenced-Test
//
//  Created by Nour on 2/22/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import Foundation
import Swinject
import CoreLocation

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GeofenceServiceType.self) { (_) in
            return GeofenceService(locationManager: CLLocationManager(), networkManager: RxWifi.shared)
        }
        .inObjectScope(.container)
    }
}
