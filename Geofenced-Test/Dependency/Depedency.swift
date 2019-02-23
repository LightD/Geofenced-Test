//
//  Depedency.swift
//  Geofenced-Test
//
//  Created by Nour on 2/21/19.
//  Copyright © 2019 Nour. All rights reserved.
//

import Foundation
import Swinject

struct Dependency {
    fileprivate var assembler: Assembler!

    static var shared: Dependency = {
        return Dependency()
    }()
    
    private init() {}
    
    static func initialize() {
        Dependency.shared.assembler = Assembler([ServiceAssembly(), ViewModelAssembly()])
    }
    
    static func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return Dependency.shared.assembler.resolver.resolve(serviceType)
    }
}
