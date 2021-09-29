//
//  IndicatorView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI

struct IndicatorView: View {
    
    var angle: Float
    var distance: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke()
            CircleView(distance: distance)
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

private struct CircleView: View {
    
    let unitDistance: Float = 100.0
    let colors: [Color] = [.blue, .green, .yellow, .orange, .red]
    let distance: Float
    
    var body: some View {
        ZStack {
            ForEach(0..<colors.count) { index in
                let to = calcTrimTo(index)
                Circle()
                    .trim(from: 1-to, to: 1)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 10, lineCap: .round, lineJoin: .round)
                    )
                    .foregroundColor(colors[index])
                    .rotationEffect(Angle(degrees: -90))
            }
        }
    }
    
    func calcTrimTo(_ index: Int) -> CGFloat {
        let remainedDistance = max(distance - (unitDistance * Float(index)), 0)
        return CGFloat(min(1, remainedDistance/unitDistance))
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
        IndicatorView(angle: 0, distance: 60)
    }
}
