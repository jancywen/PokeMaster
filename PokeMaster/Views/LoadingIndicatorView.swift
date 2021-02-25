//
//  LoadingIndicatorView.swift
//  PokeMaster
//
//  Created by captain on 2021/2/24.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI
import UIKit

struct LoadingIndicatorView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<LoadingIndicatorView>) -> UIView {
        let view = UIActivityIndicatorView(style: .medium)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoadingIndicatorView>) {
        
    }
    
}
