//
//  SpoitDataStore.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/05/30.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

class SpotDataStore: ObservableObject {
    @Published private var spotIndex: Int = 0 {
        didSet {
            spotData = repository.findAll()[spotIndex] ?? SpotData.createDataList()[0]
        }
    }
    @Published var spotData: SpotData = SpotData.createDataList()[0]
    @Published var locationFetcher = LocationFetcher.shared
    
    private let repository: SpotRepository = SpotRepository()
    
    var angle: Float {
        guard let lastLocation = locationFetcher.lastKnownLocation,
              let lastHeading = locationFetcher.lastKnownHeading else { return 0 }
        return lastLocation.angle(target: spotData.location) - Float(lastHeading.magneticHeading)
    }
    
    var distance: Float {
        guard let lastLocation = locationFetcher.lastKnownLocation else { return 0 }
        return Float(spotData.distance(from: lastLocation))
    }
    

    func setIndex(_ index: Int) {
        spotIndex = index
    }
    
    func loadAll() -> [SpotData] {
        repository.findAll()
    }
}
