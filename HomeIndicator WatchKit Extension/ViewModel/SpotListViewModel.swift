//
//  SpotListViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

class SpotListViewModel: ObservableObject {
    
    private let spotRepository: SpotRepository
    
    private let indexRepository: IndexRepository
    
    @Published var spotDataList = [SpotData]()
    
    init(
        spotRepository: SpotRepository = SpotRepositoryImpl(),
        indexRepository: IndexRepository = IndexRepositoryImpl()
    ) {
        self.spotRepository = spotRepository
        self.indexRepository = indexRepository
    }
    
    func onAppear() {
        spotDataList = spotRepository.findAll()
    }
    
    func onSelected(at index: Int) {
        indexRepository.set(index)
    }
}
