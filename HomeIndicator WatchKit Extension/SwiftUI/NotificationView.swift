//
//  NotificationView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI
import Foundation

struct NotificationView: View {
    var body: some View {
        Text(NSLocalizedString(
            "notification.hello_world",
            tableName: nil,
            bundle: .main,
            value: "Hello, World!",
            comment: ""
        ))
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
