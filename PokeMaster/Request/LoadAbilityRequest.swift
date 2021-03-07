//
//  LoadAbilityRequest.swift
//  PokeMaster
//
//  Created by captain on 2021/3/6.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import Foundation
import Combine

struct LoadAbilityRequest {
    let pokemon: Pokemon
    
    func abilityPublisher(_ url: URL) -> AnyPublisher<AbilityViewModel, AppError> {
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map{ $0.data }
            .decode(type: Ability.self, decoder: appDecoder)
            .map{ AbilityViewModel(ability: $0) }
            .mapError{ AppError.networkingFailed($0)}
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var publisher: AnyPublisher<[AbilityViewModel], AppError> {
        pokemon.abilities
            .reduce([URL](), { $0 + [$1.id] })
            .compactMap{abilityPublisher($0)}
            .zipAll
    }
    
}
