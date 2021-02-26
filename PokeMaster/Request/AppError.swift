//
//  AppError.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    case passwordWrong
    case networkingFailed(Error)
    
    var id: String {localizedDescription}
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong:
            return "密码错误"
        case .networkingFailed(let error):
            return error.localizedDescription
        }
    }
}
