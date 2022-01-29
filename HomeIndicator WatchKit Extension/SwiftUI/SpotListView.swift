//
//  SpotListView.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import SwiftUI

struct SpotListView: View {
    
    @ObservedObject var viewModel: SpotListViewModel = SpotListViewModel()
    
    @State var isShowingSheet = false
    @State var selectedIndex: Int?
    
    var body: some View {
        List {
            ForEach(viewModel.spotDataList.indices, id: \.self) { index in
                Button(action: {
                    isShowingSheet = true
                    selectedIndex = index
                }, label: {
                    SpotDataView(spotData: viewModel.spotDataList[index])
                })
            }.onDelete { indexSet in
                guard let index = indexSet.first else { return }
                viewModel.onDeleted(at: index)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: SpotRegisterView()) {
                    Text("スポット追加")
                }
            }
        }
        .actionSheet(isPresented: $isShowingSheet) {
            ActionSheet(title: Text("スポット変更"),
                        message: Text("このスポットを目的地に設定しますか？"),
                        buttons: [
                            .default(Text("はい"), action: {
                                guard let selectedIndex = selectedIndex else {
                                    return
                                }
                                viewModel.onSelected(at: selectedIndex)
                                self.selectedIndex = nil
                            })
                        ]
            )
        }
    }
}

struct SpotDataView: View {
    
    var spotData: SpotData
    
    var body: some View {
        HStack {
            Text(spotData.name)
        }
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView()
    }
}
