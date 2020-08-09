//
//  ContentView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let locationManager = CLLocationManager()
    
    @State var currentLocation: CLLocation? = CLLocation()
    
    @State var spotData = SpotData.createDataList()[0]

    var body: some View {
        VStack {
            SpotDataView(spotData: spotData)
            Divider()
            Text(currentLocation?.distance(from: spotData.location).description ?? "")
            Text(currentLocation?.angle(target: spotData.location).description ?? "")
            Button(action: {
                self.locationManager.requestWhenInUseAuthorization()
                self.currentLocation = self.locationManager.location
            }) {
                Text("現在地更新")
            }
            NavigationLink(destination: SpotListView()) {
                Text("登録スポット一覧")
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
        return (0..<size).map { SpotData(name: "spot\($0)", location: CLLocation())}
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
