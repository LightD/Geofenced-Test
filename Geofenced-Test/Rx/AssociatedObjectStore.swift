//
//  AssociatedObjectStore.swift
//  Geofenced-Test
//
//  Created by Nour on 2/22/19.
//  Copyright © 2019 Nour. All rights reserved.
//


import ObjectiveC

protocol AssociatedObjectStore {
}

extension AssociatedObjectStore {
    
    func synchronizedObject<T>(_ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
    
    func associatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    
    func associatedObject<T>(forKey key: UnsafeRawPointer, default: @autoclosure () -> T) -> T {
        return synchronizedObject {
            if let object: T = self.associatedObject(forKey: key) {
                return object
            }
            let object = `default`()
            self.setAssociatedObject(object, forKey: key)
            return object
        }
    }
    
    func setAssociatedObject<T>(_ object: T?, forKey key: UnsafeRawPointer) {
        return synchronizedObject {
            objc_setAssociatedObject(self, key, object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
