//
//  ContentViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/05.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    @Published private var spotIndex: Int = 0 {
        didSet {
            spotData = spotRepository.findAll()[spotIndex] ?? SpotData.createDataList()[0]
        }
    }
    @Published var spotData: SpotData = SpotData.createDataList()[0]
    @Published var locationFetcher = LocationFetcher.shared
    
    private let spotRepository: SpotRepositoryProtocol
    private let indexRepository: IndexRepositoryProtocol
    
    var spotName: String { spotData.name }
    
    init(
        spotRepository: SpotRepositoryProtocol = SpotRepositoryImpl(),
        indexRepository: IndexRepositoryProtocol = IndexRepository()
    ) {
        self.spotRepository = spotRepository
        self.indexRepository = indexRepository
    }
    
    func onAppear() {
        locationFetcher.start()
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
    
    func setIndex(_ index: Int) {
        indexRepository.set(index)
        spotData = spotRepository.findAll()[index]
    }
    
    func loadAll() -> [SpotData] {
        spotRepository.findAll()
    }
    
    func delete(at index: Int) {
        let spot = spotRepository.findAll()[index]
        _ = spotRepository.delete(uuid: spot.id)
        setIndex(0)
    }
}
