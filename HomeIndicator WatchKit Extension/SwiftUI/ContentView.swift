//
//  ContentView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI
import ClockKit

struct ContentView: View {
    
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                Text(viewModel.spotName)
                IndicatorView(angle: viewModel.angle, distance: viewModel.distance)
                    .frame(width: 120, height: 120, alignment: .center)
                Text("目的地まで\(String(format: "%.2f", viewModel.distance))m")
            }
        }.onAppear {
            viewModel.onAppear()
        }.toolbar {
            ToolbarItem(placement: .primaryAction){
                NavigationLink(destination: SpotListView()) {
                    Text("スポット一覧")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
