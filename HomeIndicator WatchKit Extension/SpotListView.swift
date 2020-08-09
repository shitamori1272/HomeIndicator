//
//  SpotListView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI

struct SpotListView: View {
    
    @State var spotDataList: [SpotData] = SpotData.createDataList()
    
    var body: some View {
        List {
            NewSpotView()
            ForEach(spotDataList) { spotData in
                SpotDataView(spotData: spotData)
            }
        }
    }
}

struct NewSpotView: View {
    var body: some View {
        HStack {
            Text("新しいスポット")
            NavigationLink(destination: WatchMapView()) {
                Image("icn_plus")
                    .resizable()
                    .scaledToFit()
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

struct WatchMapView: WKInterfaceObjectRepresentable {

    func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<WatchMapView>) -> WKInterfaceMap {
        return WKInterfaceMap()
    }
    
    func updateWKInterfaceObject(_ map: WKInterfaceMap, context: WKInterfaceObjectRepresentableContext<WatchMapView>) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.02,
            longitudeDelta: 0.02)
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(),
            span: span)
        
        map.setRegion(region)
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView()
    }
}
