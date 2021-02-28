//
//  RegisterRequest.swift
//  PokeMaster
//
//  Created by wangwenjie on 2021/2/28.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine


struct RegisterRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<Bool, AppError> {
        Future<Bool, AppError> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if password.count < 6 {
                    promise(.failure(.passwordWrong))
                }else {
                    promise(.success(true))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
