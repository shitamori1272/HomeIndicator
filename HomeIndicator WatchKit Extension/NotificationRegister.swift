//
//  NotificationRegister.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/12.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import UserNotifications

class NotificationRegister {
    
    private static let notificationCenter = UNUserNotificationCenter.current()
    
    static func registerSessionEndedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Session終了"
        content.body = "Sessionが終了しました。"
        content.sound = UNNotificationSound.default
        let request = UNNotificationRequest(identifier: "sessionEnd",
                                            content: content,
                                            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false))
        notificationCenter.add(request, withCompletionHandler: {_ in })
    }
    
    static func requestNotificationAutholization()  {
        notificationCenter.requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {_,_ in })
    }
}
