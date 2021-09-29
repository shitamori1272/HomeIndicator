//
//  SpotListView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI

struct SpotListView: View {
    
    @ObservedObject var spotDataStore: SpotDataStore
    
    @State var isShowingSheet = false
    @State var selectedIndex: Int?
    
    var body: some View {
        List {
            NewSpotView()
            ForEach(0..<spotDataStore.loadAll().count) { index in
                Button(action: {
                    isShowingSheet = true
                    selectedIndex = index
                }, label: {
                    SpotDataView(spotData: spotDataStore.loadAll()[index])
                })
            }
        }
//        .onDelete { index in
//            spotDataStore.delete(at: index)
//        }
        .actionSheet(isPresented: $isShowingSheet) {
            ActionSheet(title: Text("スポット変更"),
                        message: Text("このスポットを設定します？"),
                        buttons: [
                            .default(Text("はい"), action: {
                                spotDataStore.setIndex(selectedIndex ?? 0)
                            })
                        ]
            )
        }
    }
}

struct NewSpotView: View {
    var body: some View {
        HStack {
            Text("新しいスポット")
            NavigationLink(destination: SpotRegisterView(mapRegion: MKCoordinateRegion(center: LocationFetcher.shared.lastKnownLocation!.coordinate, span: .init()))) {
                Image("icn_plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
            }
        }
    }
}


struct SpotDataView: View {
    
    var spotData: SpotData
    
    var body: some View {
        HStack {
            Text(spotData.name)
            Text(spotData.location.text)
        }
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView(spotDataStore: SpotDataStore())
    }
}
