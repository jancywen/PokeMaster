//
//  Store.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

class Store: ObservableObject {
    
    var cancelBag = CancelBag()
    
    @Published var appState = AppState()
    
    init() {
        setupObservers()
    }
    private func setupObservers() {
        appState.settings.checker.isEmailValid.sink { isValid in
            self.dispatch(
                .emailValid(valid: isValid)
            )
        }.cancel(by: cancelBag)
        
        appState.settings.checker.isBtnEnable.sink { enable in
            self.dispatch(.enableBtn(enable: enable))
        }.cancel(by: cancelBag)
    }
    
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND]: \(command)")
            #endif
            command.execute(in: self)
        }
    }
    
}
extension Store {
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        
        switch action {
        case .login(email: let email, password: let password):
            guard !appState.settings.loginRequesting else {
                break
            }
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
        
        case .accountBehaviorDone(result: let result):
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                print("Error: \(error)")
                appState.settings.loginError = error
            }
            appState.settings.loginRequesting = false
            
        case .register(email: let email, password: let password):
            guard !appState.settings.registerRequesting else {
                break
            }
            appState.settings.registerRequesting = true
            appCommand = RegisterCommand(email: email, password: password)
            
        case .accountRegisterDone(result: let result):
            switch result {
            case .success(_):
                appState.settings.checker.accountBehavior = .login
            case .failure(let error):
                print("register Error: \(error)")
                appState.settings.registerError = error
            }
            appState.settings.registerRequesting = false
        case .logout:
            appState.settings.loginUser = nil
            
        case .emailValid(valid: let isValid):
            appState.settings.isEmailValid = isValid
            
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons {
                break
            }
            appState.pokemonList.loadingPokemons = true
            appCommand = LoadPokemonCommand()
            
        case .loadPokemonsDone(result: let result):
            switch result {
            case .success(let models):
                appState.pokemonList.pokemons = Dictionary( uniqueKeysWithValues: models.map{($0.id, $0)})
            case .failure(let error):
                print(error)
                appState.pokemonList.loadingPokemonsError = error
            }
            
        case .enableBtn(enable: let enable):
            appState.settings.isOperatable = enable
        
        case .clearCache:
//            appState.pokemonList.pokemons = nil
            try? FileHelper.delete(
                from: .documentDirectory,
                fileName: "pokemon.json"
            )
            
        case .toggleListSelection(index: let index):
            appState.pokemonList.expandingIndex =
                appState.pokemonList.expandingIndex == index
                ? nil
                : index

        case .loadAbilities(pokemon: let pokemon):
            if appState.pokemonList.loadingAbilitys {
                break
            }
            appState.pokemonList.loadingAbilitys = true
            appCommand = LoadAbilityCommand(pokemon: pokemon)

        case .loadAbilitiesDone(result: let result):
            switch result {
            case .success(let abilities):
                if appState.pokemonList.abilities == nil {
                    appState.pokemonList.abilities = [Int : AbilityViewModel]()
                }
                for ability in abilities {
                    if !appState.pokemonList.abilities!.contains(where: {ability.id == $0.key}) {
                        appState.pokemonList.abilities?.updateValue(ability, forKey: ability.id)
                    }
                }
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
        return (appState, appCommand)
    }
}
