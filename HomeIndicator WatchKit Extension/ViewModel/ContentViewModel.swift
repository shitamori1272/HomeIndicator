//
//  ContentViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/05.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation
import CoreGraphics
import Combine

class ContentViewModel: ObservableObject {
    
    @Published var spotData: SpotData = SpotData.createDataList()[0]
    let locationFetcher = LocationFetcher.shared
    
    @Published var angle: CGFloat = 0
    @Published var distance: CGFloat = 0
    
    private let spotRepository: SpotRepository
    private let indexRepository: IndexRepository
    
    var spotName: String { spotData.name }
    
    var cancellables = Set<AnyCancellable>()
    
    init(
        spotRepository: SpotRepository = SpotRepositoryImpl(),
        indexRepository: IndexRepository = IndexRepositoryImpl()
    ) {
        self.spotRepository = spotRepository
        self.indexRepository = indexRepository
        
        updateAngleAndDistance()
        
        locationFetcher.locationPublisher().sink { [weak self] _ in
            guard let self = self else { return }
            self.updateAngleAndDistance()
        }.store(in: &cancellables)
    }
    
    func updateAngleAndDistance() {
        guard let lastLocation = locationFetcher.lastKnownLocation,
              let lastHeading = locationFetcher.lastKnownHeading else { return }
        angle = CGFloat(lastLocation.angle(target: spotData.location) - Float(lastHeading.magneticHeading))
        distance = spotData.distance(from: lastLocation)
    }
    
    func onAppear() {
        locationFetcher.start()
        let index = indexRepository.get()
        let spotDataList = spotRepository.findAll()
        if spotDataList.indices.contains(index) {
            spotData = spotDataList[index]
        }
    }
}
