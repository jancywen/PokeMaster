//
//  PokemonList.swift
//  PokeMaster
//
//  Created by captain on 2021/2/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

struct PokemonList: View {
    
    @State var expandingIndex: Int?
    @State var searchText: String = ""
    var body: some View {
        
        if #available(iOS 14.0, *) {
            ScrollView {
                LazyVStack(content: {
                    
                    TextField("搜索", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    ForEach(PokemonViewModel.all) { pokemon in
                        
                        PokemonInfoRow(
                            model: pokemon,
                            expanded: self.expandingIndex == pokemon.id
                        )
                        .onTapGesture{
                            if self.expandingIndex == pokemon.id {
                                self.expandingIndex = nil
                            }else {
                                self.expandingIndex = pokemon.id
                            }
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
                    expanded: self.expandingIndex == pokemon.id
                )
                .onTapGesture{
                    if self.expandingIndex == pokemon.id {
                        self.expandingIndex = nil
                    }else {
                        self.expandingIndex = pokemon.id
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
        PokemonList()
    }
}
