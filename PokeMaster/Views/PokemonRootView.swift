//
//  PokemonRootView.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonRootView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            
            
            
            if store.appState.pokemonList.loadingPokemonsError == nil {
                if store.appState.pokemonList.pokemons == nil {
                    Text("Loading....").onAppear(
                        perform: { self.store.dispatch(.loadPokemons) }
                    )
                }else {
                    PokemonListView().navigationBarTitle("Pokemon")
                }
            }else {
                Button {
                    store.appState.pokemonList.loadingPokemonsError = nil
                } label: {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
            }
            
        }
    }
}

struct PokemonRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRootView()
    }
}
