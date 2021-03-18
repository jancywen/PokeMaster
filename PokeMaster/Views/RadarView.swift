//
//  RadarView.swift
//  PokeMaster
//
//  Created by captain on 2021/3/18.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import SwiftUI

struct RadarView: View {
    
    let max: Int
    let values: [Int]
    let color: Color
    
    var body: some View {
        GeometryReader {proxy in
            ZStack {
                Hexagon(
                    values: Array(repeating: self.max, count: 6),
                    max: self.max
                )
                .stroke(
                    style: StrokeStyle(lineWidth: 2,
                                       dash: [6,3])
                )
                .foregroundColor(self.color.opacity(0.5))
                
                Hexagon(values: self.values,
                        max: self.max,
                        progress: 1.0)
                    .fill(self.color)
                    .animation(.linear(duration: 0.35))
            }
            .frame(
                width:  min(proxy.size.width, proxy.size.height),
                height:  min(proxy.size.width, proxy.size.height))
        }
        
    }
}



struct Hexagon: Shape {
    
    let values: [Int]
    let max: Int
    var progress: CGFloat = 1.0
    
    func path(in rect: CGRect) -> Path {
        Path {path in
            let points = self.points(in: rect)
            path.move(to: points.first!)
            for p in points.dropFirst() {
                path.addLine(to: p)
            }
            path.closeSubpath()
        }.trimmedPath(from: 0, to: progress)
    }

    
    func points(in rect: CGRect) -> [CGPoint] {
        
        func scaleWidth(_ value: Int) -> CGFloat {
            return CGFloat(value) / CGFloat(max) * rect.width/2
        }
        
        func scaleHeight(_ value: Int) -> CGFloat {
            return CGFloat(value) / CGFloat(max) * rect.height/2
        }
        // 0.5  0.866
        
        let fir = CGPoint(x: rect.width/2, y: rect.height/2 - scaleHeight(values[0]))
        
        let sec = CGPoint(x: rect.width/2 + 0.866 * scaleWidth(values[1]), y: rect.height/2 - 0.5 * scaleHeight(values[1]))
        
        let thi = CGPoint(x: rect.width/2 + 0.866 * scaleWidth(values[2]), y: rect.height/2 + 0.5 * scaleHeight(values[2]))
        
        let four = CGPoint(x: rect.width/2, y: rect.height/2 + scaleHeight(values[3]))
        
        let fif = CGPoint(x: rect.width/2 - 0.866 * scaleWidth(values[4]), y: rect.height/2 + 0.5 * scaleHeight(values[4]))
        
        let six = CGPoint(x: rect.width/2 - 0.866 * scaleWidth(values[5]), y: rect.height/2 - 0.5 * scaleHeight(values[5]))
        
        return [fir, sec, thi, four, fif, six]
    }
}

struct RadarView_Previews: PreviewProvider {
    static var previews: some View {
        RadarView(max: 6, values: [5, 4, 3, 3, 4, 3], color: Color.green)
    }
}
