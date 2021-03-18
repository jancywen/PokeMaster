//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by captain on 2021/2/23.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {
    
    @EnvironmentObject var store: Store

    let model: PokemonViewModel
    
    var abilities: [AbilityViewModel] {
//        AbilityViewModel.sample(pokemonID: model.id)
        store.appState.pokemonList.abilityViewModel(for: model.pokemon) ?? []
    }
    
    
    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }
    
    var pokemonDescription: some View {
        Text(model.descriptionText)
            .font(.callout)
            .foregroundColor(Color(hex: 0x666666))
            .fixedSize(horizontal: false, vertical: true)
    }
    var body: some View {
        VStack(spacing: 20) {
            topIndicator
            Header(model: model)
            pokemonDescription
            Divider()
            
            HStack(spacing: 20) {
                AbilityList(model: model, abilityModels: abilities)
                RadarView(max: 120,
                          values: model.pokemon.stats.map{$0.baseStat},
                          color: model.color)
                    .frame(width: 100, height: 100)
            }
        }
        .padding(EdgeInsets(top: 12, leading: 30, bottom: 30, trailing: 30))
//        .background(Color.white)
        .blurBackground(style: .systemMaterial)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

extension PokemonInfoPanel {
    struct Header: View {
        let model: PokemonViewModel
        
        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon
                nameSpecies
                verticalDivider
                VStack {
                    bodyStatus
                    typeInfo.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
        
        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68, alignment: .center)
        }
        
        var nameSpecies: some View {
            VStack(alignment: .center) {
                Text(model.name)
                    .font(Font.custom("pingfang SC Bold", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(model.color)
                Text(model.nameEN)
                    .font(Font.custom("pingfang", size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(model.color)

                Text(model.genus)
                    .font(Font.custom("pingfang", size: 13))
                    .foregroundColor(.gray)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            }
        }
        
        var verticalDivider: some View {
            Rectangle()
                .frame(width: 1, height: 44, alignment: .center)
                .foregroundColor(Color(hex: 0x000000))
                .opacity(0.1)
        }
        
        var bodyStatus: some View {
            VStack {
                HStack {
                    Text("身高")
                        .font(Font.custom("pingfang regular", size: 11))
                        .foregroundColor(.gray)
                    Text(model.height)
                        .font(Font.custom("pingfang regular", size: 11))
                        .foregroundColor(model.color)
                }
                HStack {
                    Text("体重")
                        .font(Font.custom("pingfang regular", size: 11))
                        .foregroundColor(.gray)
                    Text(model.weight)
                        .font(Font.custom("pingfang regular", size: 11))
                        .foregroundColor(model.color)
                }
            }
        }
        
        var typeInfo: some View {
            HStack {
                
                ForEach(model.types) { type in
                    Text(type.name)
                        .font(Font.custom("pingfang regular", size: 9))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 14, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 7)
                                .frame(width: 36, height: 14, alignment: .center)
                                .foregroundColor(type.color)
                        )
                }
            }
        }
    }
    
}

extension PokemonInfoPanel {
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12, content: {
                Text("技能")
                    .font(.headline)
                    .fontWeight(.bold)
                
                if abilityModels != nil {
                    ForEach(abilityModels!) {ability in
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(self.model.color)
                        
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xaaaaaa))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }).frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: PokemonViewModel.sample(id: 1))
    }
}
