//
//  ContentViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/05.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

<<<<<<< Updated upstream:HomeIndicator WatchKit Extension/Domain/DataStore/SpoitDataStore.swift
class SpotDataStore: ObservableObject {
    @Published var spotData: SpotData?
=======
class ContentViewModel: ObservableObject {
    
    @Published private var spotIndex: Int = 0 {
        didSet {
            spotData = spotRepository.findAll()[spotIndex] ?? SpotData.createDataList()[0]
        }
    }
    @Published var spotData: SpotData = SpotData.createDataList()[0]
>>>>>>> Stashed changes:HomeIndicator WatchKit Extension/ViewModel/ContentViewModel.swift
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
        spotRepository.findAll()
    }
    
    func delete(at index: Int) {
        let spot = repository.findAll()[index]
        _ = repository.delete(uuid: spot.id)
        setIndex(0)
    }
}
