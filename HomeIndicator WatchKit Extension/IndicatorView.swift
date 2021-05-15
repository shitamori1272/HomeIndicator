//
//  IndicatorView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI

struct IndicatorView: View {
    
    var angle: CGFloat
    var distance: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke()
            Circle()
                .inset(by: 20)
                .stroke()
                .foregroundColor(.red)
            ArrowView()
                .rotationEffect(.degrees(Double(angle)))
                .animation(.linear)
        }
    }
}

private struct ArrowView: View {
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
            Triangle()
                .frame(width: 40, height: 20, alignment: .center)
                .foregroundColor(.red)
            Rectangle()
                .frame(width: 20, height: 50, alignment: .center)
                .foregroundColor(.red)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView(angle: 0, distance: 20)
    }
}
