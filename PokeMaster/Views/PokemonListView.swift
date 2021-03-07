//
//  PokemonList.swift
//  PokeMaster
//
//  Created by captain on 2021/2/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

struct PokemonListView: View {
    
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        
        if #available(iOS 14.0, *) {
            ScrollView {
                LazyVStack(content: {
                    
                    TextField("搜索", text: $store.appState.pokemonList.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    ForEach(store.appState.pokemonList.allPokemonsByID) { pokemon in
                        
                        PokemonInfoRow(
                            model: pokemon,
                            expanded: store.appState.pokemonList.expandingIndex == pokemon.id
                        )
                        .onTapGesture{
                            
                            store.dispatch(
                                .toggleListSelection(index: pokemon.id)
                            )
                            
                            store.dispatch(
                                .loadAbilities(pokemon: pokemon.pokemon)
                            )
                        }
                    }
                })
            }
//            .overlay(
//                VStack{
//                    Spacer()
//                    PokemonInfoPanel(model: .sample(id: expandingIndex ?? 1))
//                        
//                }.edgesIgnoringSafeArea(.bottom)
//            )
        } else {
            List(PokemonViewModel.all){ pokemon in
                PokemonInfoRow(
                    model: pokemon,
                    expanded: store.appState.pokemonList.expandingIndex == pokemon.id
                )
                .onTapGesture{
                    if store.appState.pokemonList.expandingIndex == pokemon.id {
                        store.dispatch(
                            .toggleListSelection(index: nil)
                        )
                    }else {
                        store.dispatch(
                            .toggleListSelection(index: pokemon.id)
                        )
                    }
                }
            }.modifier(ListRemoveSeparator())
        }
    }
}


struct ListRemoveSeparator: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                UITableView.appearance().tableFooterView = UIView()
                UITableView.appearance().separatorStyle = .none
            })
            .onDisappear(perform: {
                UITableView.appearance().tableFooterView = nil
                UITableView.appearance().separatorStyle = .singleLine
            })
    }
}


struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
