//
//  AppAction.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation


enum AppAction {
    /// 登录
    case login(email: String, password: String)
    case accountBehaviorDone(result: Result<User, AppError>)
    /// 注册
    case register(email: String, password: String)
    case accountRegisterDone(result: Result<String, AppError>)
    
    /// 注销
    case logout
    /// 验证邮箱
    case emailValid(valid: Bool)
    /// btnenable
    case enableBtn(enable: Bool)
    
    /// 加载 Pokemons
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
    
    /// 清空缓存
    case clearCache
    
    /// 切换 cell 展开状态
    case toggleListSelection(index: Int?)
}
