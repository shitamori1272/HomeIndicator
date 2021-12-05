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
        
        locationFetcher.locationPublisher().sink { [weak self] _ in
            guard let self = self,
                  let lastLocation = self.locationFetcher.lastKnownLocation,
                  let lastHeading = self.locationFetcher.lastKnownHeading else {
                      return
                  }
            self.angle = CGFloat(lastLocation.angle(target: self.spotData.location) - Float(lastHeading.magneticHeading))
            self.distance = self.spotData.distance(from: lastLocation)
        }.store(in: &cancellables)
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
