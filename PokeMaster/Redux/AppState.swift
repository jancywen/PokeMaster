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
    
    var pokemonList = PokemonList()
    
    var mainTab = MainTab()
}

extension AppState {
    struct Settings {
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json")
        var loginUser: User?
        
        var loginRequesting: Bool = false
        var loginError: AppError?
        
        var registerRequesting: Bool = false
        var registerError: AppError?
        
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
            
            ///验证邮箱
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
            
            // 验证密码
            var isPasswordValid: AnyPublisher<Bool, Never> {
                
                return Publishers.CombineLatest3 (
                    $accountBehavior.map{ $0 == .login}, $password, $verifyPassword
                ).map { skip, pw, vpw in
                    if skip {
                        return !pw.isEmpty
                    }else {
                        return !pw.isEmpty && !vpw.isEmpty && pw == vpw
                    }
                }.eraseToAnyPublisher()
            }
            
            /// 按钮可点击
            var isBtnEnable: AnyPublisher<Bool, Never> {
                return Publishers
                    .CombineLatest(isEmailValid, isPasswordValid)
                    .map{ $0 && $1 }
                    .eraseToAnyPublisher()
            }
        }
        
        var checker = AccountChecker()
        
        var isEmailValid: Bool = false
        
        var isOperatable: Bool = false
        
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


extension AppState {
    struct PokemonList {
        @FileStorage(directory: .documentDirectory, fileName: "pokemon.json")
        var pokemons: [Int: PokemonViewModel]?
        
        var loadingPokemons = false
        var loadingPokemonsError: AppError?
        
        /// 展开cell的index
        var expandingIndex:Int? = nil
        var searchText = ""
        
        var allPokemonsByID: [PokemonViewModel] {
            guard let pokemons = pokemons?.values else {
                return []
            }
            return pokemons.sorted{$0.id < $1.id}
        }
        
        var loadingAbilitys = false
        // 按ID缓存所有 AbilityViewModel
        var abilities: [Int: AbilityViewModel]?
        // 返回某个 pokemon 的所有技能的 AbilityViewModel
        func abilityViewModel(
            for pokemon: Pokemon
        ) -> [AbilityViewModel]? {
            return pokemon.abilities.map{$0.ability.url.extractedID}.filter{$0 != nil}.map{ abilities?[$0!] }.filter{$0 != nil}.map{$0!}
        }
        
        struct SelectionState {
            var panelPresented = false
        }
        var selectionState = SelectionState()
        
        var showingAlert = false
        
    }
}


extension AppState {
    struct MainTab {
        enum Index: Hashable {
            case list, setting
        }
        
        var selection: Index = .list
    }
}
