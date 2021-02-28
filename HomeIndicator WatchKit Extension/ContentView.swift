//
//  ContentView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var locationFetcher = LocationFetcher()

    @State var spotData = SpotData.createDataList()[0]
    
    var angle: CGFloat {
        guard let lastLocation = locationFetcher.lastKnownLocation,
              let lastHeading = locationFetcher.lastKnownHeading else { return 0 }
        return lastLocation.angle(target: spotData.location) + CGFloat(lastHeading.magneticHeading)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                SpotDataView(spotData: spotData)
                Divider()
                IndicatorView(angle: angle, distance: 0)
                    .frame(width: 100, height: 100, alignment: .center)
                Text(locationFetcher.lastKnownLocation?.distance(from: spotData.location).description ?? "")
                Text(angle.description)
                Button(action: {
                    self.locationFetcher.start()
                }) {
                    Text("現在地更新")
                }
                NavigationLink(destination: SpotListView()) {
                    Text("登録スポット一覧")
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

struct SpotData: Identifiable {
    var id = UUID()
    var name: String
    let updateDate = Date()
    let location: CLLocation
    var lat: CLLocationDegrees { location.coordinate.latitude }
    var lon: CLLocationDegrees { location.coordinate.longitude }
    
    init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
    }
    
    static func createDataList() -> [SpotData] {
        let size = 4
        return (0..<size).map { SpotData(name: "spot\($0)", location: CLLocation(latitude: 35.709352, longitude: 139.8253409))}
    }
}

extension CLLocation {
    
    var text: String {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        return "\(lat), \(lon)"
    }
    
    func angle(target: CLLocation) -> CGFloat {
        func toRadian(_ angle: CLLocationDegrees) -> CGFloat { CGFloat(angle) * CGFloat.pi / 180 }
        
        let currentLatitude     = toRadian(coordinate.latitude)
        let currentLongitude    = toRadian(coordinate.longitude)
        let targetLatitude      = toRadian(target.coordinate.latitude)
        let targetLongitude     = toRadian(target.coordinate.longitude)
        
        let difLongitude = targetLongitude - currentLongitude
        let y = sin(difLongitude)
        let x = cos(currentLatitude) * tan(targetLatitude) - sin(currentLatitude) * cos(difLongitude)
        let p = atan2(y, x) * 180 / CGFloat.pi
        
        if p < 0 {
            return 360 + atan2(y, x) * 180 / CGFloat.pi
        }
        return atan2(y, x) * 180 / CGFloat.pi
    }
}
