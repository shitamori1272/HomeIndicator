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

    @ObservedObject var dataStore: SpotDataStore = SpotDataStore()
    
    var body: some View {
        ScrollView {
            VStack {
                Text(dataStore.spotData.name)
                IndicatorView(angle: dataStore.angle, distance: 0)
                    .frame(width: 100, height: 100, alignment: .center)
                Text("目的地まで\(String(format: "%.2f",dataStore.distance))m")
                Text("\(String(format: "%.2f", dataStore.angle))度")
                NavigationLink(destination: SpotListView(spotDataStore: dataStore)) {
                    Text("登録スポット一覧")
                }
            }
        }.onAppear {
            dataStore.locationFetcher.start()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
