//
//  ContentViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/05.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published var spotData: SpotData!
    @Published var locationFetcher = LocationFetcher.shared
    
    private let spotRepository: SpotRepository
    private let indexRepository: IndexRepository
    
    var spotName: String { spotData?.name ?? "" }
    
    init(
        spotRepository: SpotRepository = SpotRepositoryImpl(),
        indexRepository: IndexRepository = IndexRepositoryImpl()
    ) {
        self.spotRepository = spotRepository
        self.indexRepository = indexRepository
    }
    
    func onAppear() {
        locationFetcher.start()
        let index = indexRepository.get()
        let spotDataList = spotRepository.findAll()
        if spotDataList.indices.contains(index) {
            spotData = spotDataList[index]
        }
    }
    
    var angle: Float {
        guard let lastLocation = locationFetcher.lastKnownLocation,
              let lastHeading = locationFetcher.lastKnownHeading else { return 0 }
        return lastLocation.angle(target: spotData.location) - Float(lastHeading.magneticHeading)
    }
    
    var distance: Float {
        guard let lastLocation = locationFetcher.lastKnownLocation else { return 0 }
        return Float(spotData.distance(from: lastLocation))
    }
}
