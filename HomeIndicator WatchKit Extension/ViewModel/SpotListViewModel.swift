//
//  SpotListViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

@MainActor
class SpotListViewModel: ObservableObject {
    
    private let spotRepository: SpotRepository
    
    private let indexRepository: IndexRepository
    
    @Published var spotDataList: [SpotData]
    
    init(
        spotRepository: SpotRepository = SpotRepositoryImpl(),
        indexRepository: IndexRepository = IndexRepositoryImpl()
    ) {
        self.spotRepository = spotRepository
        self.indexRepository = indexRepository
        self.spotDataList = spotRepository.findAll()
    }
    
    func onAppear() {
        spotDataList = spotRepository.findAll()
    }
    
    func onDeleted(at index: Int) {
        guard spotDataList.indices.contains(index) else { return }
        let uuid = spotDataList[index].id
        _ = spotRepository.delete(uuid: uuid)
        spotDataList = spotRepository.findAll()
        if index == indexRepository.get() {
            indexRepository.set(0)
        }
    }
    
    func onSelected(at index: Int) {
        indexRepository.set(index)
    }
}
