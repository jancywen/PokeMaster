//
//  AppCommand.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

protocol AppCommand {
    func execute(in store: Store)
}


struct LoginAppCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        _ = LoginRequest(
            email: email,
            password: password
        )
        .publisher
        .subscribe(on: RunLoop.main)
        .sink { complete in
            if case .failure(let error) = complete {
                store.dispatch(
                    .accountBehaviorDone(result: .failure(error))
                )
            }
        } receiveValue: { user in
            store.dispatch(
                .accountBehaviorDone(result: .success(user))
            )
        }

    }
}


struct WriteUserAppCommand: AppCommand {
    
    let user: User
    
    func execute(in store: Store) {
        try? FileHelper.writeJSON(
            user,
            to: .documentDirectory,
            fileName: "user.json"
        )
    }

    
}


struct LoadPokemonCommand: AppCommand {
    func execute(in store: Store) {
        _ = LoadPokemonRequest.all.sink(receiveCompletion: { (complete) in
            if case .failure(let error) = complete {
                store.dispatch(.loadPokemonsDone(result: .failure(error)))
            }
        }, receiveValue: { (value) in
            store.dispatch(.loadPokemonsDone(result: .success(value)))
        })
    }
    
}


struct RegisterCommand: AppCommand {
    let email: String
    let password: String
    
    func execute(in store: Store) {
        _ = RegisterRequest(email: email, password: password)
            .publisher
            .subscribe(on: RunLoop.main)
            .sink(receiveCompletion: { complet in
                if case .failure(let error) = complet {
                    store.dispatch(.accountRegisterDone(result: .failure(error)))
                }
            }, receiveValue: { _ in
                store.dispatch(.accountRegisterDone(result: .success(email)))
            })
    }
}
