//
//  AppState.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

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
        
        //        var accountBehavior = AccountBehavior.login
        //        var email = ""
        //        var password = ""
        //        var verifyPassword = ""
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var isEmailValid: AnyPublisher<Bool, Never> {
                let remoteVerify = $email
                    .debounce(
                        for: .milliseconds(500),
                        scheduler: DispatchQueue.main
                    )
                    .removeDuplicates()
                    .flatMap { (email) -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        
                        switch (validEmail, canSkip) {
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true, false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                    }
                    .eraseToAnyPublisher()
                
                let emailLocalValid = $email.map{$0.isValidEmailAddress}
                let canSkipRemoteVerify = $accountBehavior.map{ $0 == .login }
                
                return Publishers.CombineLatest3(
                    emailLocalValid, canSkipRemoteVerify, remoteVerify
                )
                .map { $0 && ($1 || $2)}
                .eraseToAnyPublisher()
            }
        }
        
        var checker = AccountChecker()
        
        var isEmailValid: Bool = false
        
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
