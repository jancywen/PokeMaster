//
//  PokemonRow.swift
//  PokeMaster
//
//  Created by captain on 2021/2/20.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import Kingfisher

struct PokemonInfoRow: View {
    
//    let model = PokemonViewModel.sample(id: 1)
    let model: PokemonViewModel
    let expanded: Bool
    
    var body: some View {
        VStack {
            HStack {
                Image("Pokemon-\(model.id)")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                
//                KFImage(model.iconImageURL)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                    .aspectRatio(contentMode: .fit)
//                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                    Text(model.nameEN)
                        .font(.subheadline)
                }.foregroundColor(.white)
            }
            .padding(.top, 12)
            
            Spacer()
            
            HStack(spacing: expanded ? 20 : -30) {
                Spacer()
                Button(action: {print("Fav")}) {
                    Image(systemName: "star")
                        .modifier(ToolButtonModifier())
                }
                Button(action: {}) {
                    Image(systemName: "chart.bar")
                        .modifier(ToolButtonModifier())
                }
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .modifier(ToolButtonModifier())
                }
            }
            .padding(.bottom, 12)
            .opacity(expanded ? 1.0 : 0.0)
            .frame(maxHeight: expanded ? .infinity : 0)
        }
        .frame(height: expanded ? 120 : 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, model.color]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
            }
        )
        .padding(.horizontal)
        .animation(
            .spring(
                response: 0.55,
                dampingFraction: 0.425,
                blendDuration: 0
            )
        )
//        .onTapGesture(count: 1, perform: {
////            withAnimation {
//                self.expanded.toggle()
////            }
//        })
    }
}


struct ToolButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.system(size: 25))
            .frame(width: 30, height:30)
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PokemonInfoRow(model: PokemonViewModel.sample(id: 1), expanded: true)
            PokemonInfoRow(model: .sample(id: 21), expanded: true)
            PokemonInfoRow(model: .sample(id: 25), expanded: false)
        }
    }
}
