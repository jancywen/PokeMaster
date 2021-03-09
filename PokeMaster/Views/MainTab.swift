//
//  MainTab.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct MainTab: View {
    
    @EnvironmentObject var store: Store
    
    var selectedPanelIndex: Int? {
        store.appState.pokemonList.expandingIndex
    }
    
    var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    
    
    
    var body: some View {
        TabView(selection: $store.appState.mainTab.selection) {
            PokemonRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("列表")
            }
            .tag(AppState.MainTab.Index.list)
            
            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
            .tag(AppState.MainTab.Index.setting)
        }
        .edgesIgnoringSafeArea(.top)
        .overlay(
            OverlaySheet(
                isPresented: $store.appState.pokemonList.selectionState.panelPresented,
                content: {
                    if selectedPanelIndex != nil
                        && pokemonList.pokemons != nil
                    {
                        PokemonInfoPanelOverlay(
                            model: pokemonList.pokemons![selectedPanelIndex!]!
                        )
                    }
                })
        )
    }
    
    var panel: some View {
        Group {
            if pokemonList.selectionState.panelPresented {
                if selectedPanelIndex != nil && pokemonList.pokemons != nil {
                    PokemonInfoPanelOverlay(model: pokemonList.pokemons![selectedPanelIndex!]!)
                }else {
                    EmptyView()
                }
            }else {
                EmptyView()
            }
        }.animation(.linear)
    }
    
}


struct PokemonInfoPanelOverlay: View {
    let model: PokemonViewModel
    var body: some View {
        VStack {
            Spacer()
            PokemonInfoPanel(model: model)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
