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
