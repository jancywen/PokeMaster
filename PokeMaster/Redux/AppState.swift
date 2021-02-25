//
//  AppState.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

struct AppState {
    var settings = Settings()
}

extension AppState {
    struct Settings {
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting: Bool = false
        var loginError: AppError?
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        enum Sorting: String, CaseIterable {
            case id, name, color, favorite
        }
        
        var accountBehavior = AccountBehavior.login
        var email = ""
        var password = ""
        var verifyPassword = ""
        
        @UserDefaultsStorage<Bool>(initialValue: true, keypath: "showEnglishName")
        var showEnglishName: Bool
        
        var sorting: Sorting {
            set {
                sortingStr =  newValue.rawValue
            }
            get {
                Sorting(rawValue: sortingStr) ?? .id
            }
        }
                
        @UserDefaultsStorage<String>(initialValue: "id", keypath: "sortingStr")
        private var sortingStr: String
        
        @UserDefaultsStorage<Bool>(initialValue: false, keypath: "showFavoriteOnly")
        var showFavoriteOnly
    }
}
