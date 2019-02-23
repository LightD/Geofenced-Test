//
//  ViewModelAssembly.swift
//  Geofenced-Test
//
//  Created by Nour on 2/22/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import Foundation
import Swinject

final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewModelType.self) { (r) in
            return HomeViewModel(geoService: r.resolve(GeofenceServiceType.self)!)
        }
    }
}
