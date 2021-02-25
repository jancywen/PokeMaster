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
    @Published var appState = AppState()
    
    
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
            
        case .logout:
            appState.settings.loginUser = nil
        }
        
        return (appState, appCommand)
    }
}
