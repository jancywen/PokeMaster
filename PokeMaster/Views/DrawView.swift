//
//  DrawView.swift
//  PokeMaster
//
//  Created by captain on 2021/3/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct DrawView: View {
    var body: some View {
        
        VStack {
            
            TriangleArrow()
                .fill(Color.yellow)
                .frame(width: 100, height: 100, alignment: .center)
            
            FlowRectangle()
                .frame(height: 300)
        }
    }
}


struct TriangleArrow: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            // 零点 左上
            path.move(to: .zero)
            // 添加圆弧
            path.addArc(
                center: CGPoint(x: -rect.width / 5, y: rect.height / 2),
                radius: rect.width/2,
                startAngle: .degrees(-45),
                endAngle: .degrees(45),
                clockwise: false
            )
            
            // 添加直线
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
            
            path.closeSubpath()
        }
    }
}


struct FlowRectangle: View {
    var body: some View {
        
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 0.3 * proxy.size.height)
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 0.4 * proxy.size.width)
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 0.4 * proxy.size.height)
                        Rectangle()
                            .fill(Color.yellow)
                            .frame(height: 0.3 * proxy.size.height)
                    }
                    .frame(width: 0.6 * proxy.size.width)
                }
            }
        }
    }
}

struct DrawView_Previews: PreviewProvider {
    static var previews: some View {
        DrawView()
    }
}
