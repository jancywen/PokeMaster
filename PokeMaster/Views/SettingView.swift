//
//  SettingView.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import Combine

struct SettingView: View {
    
//    @ObservedObject var settings = Settings()
    
    @EnvironmentObject var store: Store
    var settingBinding: Binding< AppState.Settings> {
        $store.appState.settings
    }
    
    var settings: AppState.Settings {
         store.appState.settings
    }
    
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        .alert(item: settingBinding.loginError) { error in
            Alert(title: Text(error.localizedDescription))
        }
    }
    
    var accountSection: some View {
        Section(header: Text("账号")) {
            if settings.loginUser == nil {
                Picker(
                    selection: settingBinding.checker.accountBehavior,
                    label: Text("")
                ) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                TextField("电子邮箱", text: settingBinding.checker.email)
                    .foregroundColor(settings.isEmailValid ? .green : .red)
                SecureField("密码", text: settingBinding.checker.password)
                if settings.checker.accountBehavior == .register {
                    SecureField("确认密码", text: settingBinding.checker.verifyPassword)
                }
                
                if settings.loginRequesting || settings.registerRequesting {
//                    Text("登录中。。。。。")
                    LoadingIndicatorView()
                }else {
                    Button(settings.checker.accountBehavior.text) {
                        if settings.checker.accountBehavior == .login {
                            self.store.dispatch(
                                .login(
                                    email: self.settings.checker.email,
                                    password: self.settings.checker.password
                                )
                            )
                        }
                        else {
                            self.store.dispatch(
                                .register(
                                    email: self.settings.checker.email,
                                    password: self.settings.checker.password
                                )
                            )
                        }
                    }
                    .foregroundColor(settings.isOperatable ? .blue : .gray)
                    .disabled(!settings.isOperatable)
                }
            }else {
                Text(settings.loginUser!.email)
                Button("注销") {
                    store.dispatch(.logout)
                }
            }
        }
    }
    
    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: settingBinding.showEnglishName, label: {
                Text("显示英文名")
            })
            Picker(selection: settingBinding.sorting, label: Text("排序方式"), content: {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text).tag($0)
                    //                    Text($0.rawValue)
                }
            })
            Toggle("只显示收藏", isOn: settingBinding.showFavoriteOnly)
        }
    }
    
    var actionSection: some View {
        Section{
            Button("清空缓存") {
                
            }.foregroundColor(.red)
        }
    }
    
}


extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register:
            return "注册"
        case .login:
            return "登录"
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
