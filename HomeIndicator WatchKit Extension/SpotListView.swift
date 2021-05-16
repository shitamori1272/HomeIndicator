//
//  SpotListView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI
import MapKit

struct SpotListView: View {
    
    let spotRepository: SpotRepository = SpotRepositoryImpl()
    
    var body: some View {
        List {
            NewSpotView()
            let spotDataList = spotRepository.loadAll()
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
            NavigationLink(destination: RegisterView()) {
                Image("icn_plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .center)
            }
        }
    }
}

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var locationFetcher = LocationFetcher.shared
    
    @State var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    
    let spotRepository: SpotRepository = SpotRepositoryImpl()
    let spotData: SpotData = {
        let location = LocationFetcher.shared.lastKnownLocation ?? CLLocation()
        return SpotData(name: "test", location: location)
    }()
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
            Button("この地点を登録する") {
                spotRepository.register(spotData)
                presentationMode.wrappedValue.dismiss()
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
        SpotListView()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
