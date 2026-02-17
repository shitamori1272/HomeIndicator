//
//  ContentView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/02.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI
import Foundation

struct ContentView<ViewModel>: View where ViewModel: ContentViewModelProtocol  {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if viewModel.shouldShowRegisterButton {
                        NavigationLink(destination: SpotRegisterView()) {
                            Text(localized("content.register_first_spot", "最初のスポットを登録"))
                        }
                    } else {
                        Text(viewModel.spotName)
                        IndicatorView(angle: viewModel.angle, distance: viewModel.distance)
                            .frame(width: 120, height: 120, alignment: .center)
                        Text(String(
                            format: localized("content.distance_to_spot_format", "目的地まで%@m"),
                            String(format: "%.2f", viewModel.distance)
                        ))
                        NavigationLink(destination: SpotListView()) {
                            Text(localized("content.spot_list", "スポット一覧"))
                        }
                    }
                }
            }.onAppear {
                viewModel.onAppear()
            }
        }
    }

    private func localized(_ key: String, _ fallback: String) -> String {
        NSLocalizedString(key, tableName: nil, bundle: .main, value: fallback, comment: "")
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
