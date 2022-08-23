//
//  ContentView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI
import ClockKit

struct ContentView<ViewModel>: View where ViewModel: ContentViewModelProtocol  {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.shouldShowRegisterButton {
                    NavigationLink(destination: SpotRegisterView()) {
                        Text("最初のスポットを登録")
                    }
                } else {
                    Text(viewModel.spotName)
                    IndicatorView(angle: viewModel.angle, distance: viewModel.distance)
                        .frame(width: 120, height: 120, alignment: .center)
                    Text("目的地まで\(String(format: "%.2f", viewModel.distance))m")
                    NavigationLink(destination: SpotListView()) {
                        Text("スポット一覧")
                    }
                }
            }
        }.onAppear {
            viewModel.onAppear()
        }.toolbar {
            ToolbarItem(placement: .primaryAction){
                NavigationLink(destination: SpotListView()) {
                    Text("スポット一覧")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView<ContentViewModelMock>(viewModel: ContentViewModelMock())
    }
    
    class ContentViewModelMock: ContentViewModelProtocol {
        @Published var angle: CGFloat = 25
        
        @Published var distance: CGFloat = 1200
        
        @Published var spotName: String = "Homes"
        
        @Published var shouldShowRegisterButton = false
        
        func onAppear() {}
    }
}
