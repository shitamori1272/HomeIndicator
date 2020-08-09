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
    
    @State var locationText = "自宅"
    
    var body: some View {
        VStack {
            Text("登録された場所")
            Divider()
            Text(locationText)
            Divider()
            HStack {
                Button(action: {
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationText = String(describing: self.locationManager.location)
                }) {
                    Text("登録")
                    Button(action: {
                        print("test")
                    }) {
                        Image("icn_plus")
                            .resizable()
                    }
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
