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
            Rectangle()
                .frame(width: 20, height: 50, alignment: .center)
                .foregroundColor(.red)
                .rotationEffect(Angle(radians: Double(angle)))
                .animation(.linear)
        }
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView(angle: 20, distance: 20)
    }
}
