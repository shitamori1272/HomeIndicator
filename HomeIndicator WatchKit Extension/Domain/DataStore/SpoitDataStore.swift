//
//  SpoitDataStore.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/05/30.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

class SpotDataStore: ObservableObject {
    @Published var spotData: SpotData?
    @Published var locationFetcher = LocationFetcher.shared
    
    private let repository: SpotRepository = SpotRepository()
    
    init() {
        spotData = repository.findAll()[repository.getIndex()]
    }
    
    var angle: Float {
        guard let lastLocation = locationFetcher.lastKnownLocation,
              let lastHeading = locationFetcher.lastKnownHeading,
              let spotData = spotData else { return 0 }
        return lastLocation.angle(target: spotData.location) - Float(lastHeading.magneticHeading)
    }
    
    var distance: Float {
        guard let lastLocation = locationFetcher.lastKnownLocation,
              let spotData = spotData else { return 0 }
        return Float(spotData.distance(from: lastLocation))
    }
    
    func setIndex(_ index: Int) {
        repository.setIndex(index: index)
        spotData = repository.findAll()[repository.getIndex()]
    }
    
    func loadAll() -> [SpotData] {
        repository.findAll()
    }
    
    func delete(at index: Int) {
        let spot = repository.findAll()[index]
        _ = repository.delete(uuid: spot.id)
        setIndex(0)
    }
}
