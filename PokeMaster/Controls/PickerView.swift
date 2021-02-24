//
//  PickerView.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct PickerView: View {
    
    @State private var selectedFlavor = Flavor.chocolate
    
    @State var suggestedTopping: Topping = .cookies
    
    @State private var selectedTopping = Topping.nuts
    
    var body: some View {
        Picker("Flavor", selection: $selectedFlavor) {
            ForEach(Flavor.allCases) { flavor in
                Text(flavor.rawValue.capitalized).tag(flavor)
            }
        }
        Text("Selected flavor: \(selectedFlavor.rawValue)")

        Picker("Suggest a topping for:", selection: $suggestedTopping) {
            ForEach(Flavor.allCases) { flavor in
                Text(flavor.rawValue.capitalized).tag(flavor.suggestedTopping)
            }
        }
        Text("suggestedTopping: \(suggestedTopping.rawValue)")
        //
        Picker("Topping", selection: $selectedTopping) {
            ForEach(Topping.allCases) { flavor in
                Text(flavor.rawValue.capitalized).tag(flavor)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        
        Text("Selected toppping: \(selectedTopping.rawValue)")
    }
    
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
    }
}



enum Flavor: String, CaseIterable, Identifiable {
    case chocolate, vanilla, strawberry
    
    var id: String { self.rawValue }
}

enum Topping: String, CaseIterable, Identifiable {
    case nuts, cookies, blueberries
    
    var id: String { self.rawValue }
}

extension Flavor {
    var suggestedTopping: Topping {
        switch self {
        case .chocolate:
            return .nuts
        case .vanilla:
            return .cookies
        case .strawberry:
            return .blueberries
        }
    }
}
