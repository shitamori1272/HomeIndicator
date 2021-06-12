//
//  ContentView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI
import ClockKit
import UserNotifications

struct ContentView: View {

    @ObservedObject var dataStore: SpotDataStore = SpotDataStore()
    
    @ObservedObject var sessionManager = ExtendedSessionManager()
    
    var body: some View {
        ScrollView {
            VStack {
                Text(dataStore.spotData.name)
                IndicatorView(angle: dataStore.angle, distance: 0)
                    .frame(width: 100, height: 100, alignment: .center)
                Text("目的地まで\(String(format: "%.2f",dataStore.distance))m")
                Text("\(String(format: "%.2f", dataStore.angle))度")
                if !sessionManager.isRunning {
                    Button("Session開始") {
                        sessionManager.startSession()
                        // Define the custom actions.
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {_,_ in })
                        let content = UNMutableNotificationContent()
                        content.title = "お知らせ"
                        content.body = "ボタンを押しました。"
                        content.sound = UNNotificationSound.default
                        let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false))
                        notificationCenter.add(request, withCompletionHandler: {_ in })
                    }
                } else {
                    Button("Session終了") {
                        sessionManager.stopSession()
                    }
                }
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
