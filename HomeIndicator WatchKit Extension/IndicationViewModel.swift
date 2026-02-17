//
//  IndicationViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/12.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation
import Combine

@MainActor
class IndicationViewModel: ObservableObject {
    
    private let locationProvider: any LocationProvider
    var cancellables = Set<AnyCancellable>()
    
    var spotData: SpotData
    
    @Published var angle: Double = 0
    
    @Published var distance: Double = 0
    
    init?(
        spotData: SpotData?,
        locationProvider: any LocationProvider = LocationFetcher.shared
    ) {
        guard let spotData = spotData else { return nil }
        self.spotData = spotData
        self.locationProvider = locationProvider
        locationProvider.start()
        
        locationProvider.locationPublisher().sink { [weak self] _ in
            guard let self = self else { return }
            self.updateValues()
        }.store(in: &cancellables)
    }
    
    func updateValues() {
        if let lastLocation = locationProvider.lastKnownLocation {
            distance = spotData.distance(from: lastLocation)
            if let lastHeading = locationProvider.lastKnownHeading {
                let rawAngle = lastLocation.angle(target: spotData.location) - Float(lastHeading.magneticHeading)
                angle = Double(rawAngle.normalizedArrowAngle())
            }
        }
    }
}
