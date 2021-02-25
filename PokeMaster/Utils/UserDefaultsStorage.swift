//
//  UserDefaultsStorage.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import Foundation

@propertyWrapper
struct UserDefaultsStorage<T: Any> {
    
    var value: T
    var initialValue: T
    
    let keypath: String
    
    init(initialValue: T, keypath: String) {
        value = UserDefaults.standard.object(forKey: keypath) as? T ?? initialValue
        self.keypath = keypath
        self.initialValue = initialValue
    }
    
    var wrappedValue:T {
        set {
            value = newValue
            UserDefaults.standard.setValue(value, forKey: keypath)
        }
        get {
            value
        }
    }
}

