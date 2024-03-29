//
//  HostingController.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView<ContentViewModel>> {
    override var body: ContentView<ContentViewModel> {
        return ContentView<ContentViewModel>(viewModel: ContentViewModel())
    }
}
