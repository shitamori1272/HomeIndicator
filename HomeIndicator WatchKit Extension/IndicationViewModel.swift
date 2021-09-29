//
//  IndicationViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/12.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation
import Combine

class IndicationViewModel: ObservableObject {
    
    private let locationFecher = LocationFetcher.shared
    var cancellables = Set<AnyCancellable>()
    
    var spotData: SpotData
    
    @Published var angle: Double = 0
    
    @Published var distance: Double = 0
    
    init?(spotData: SpotData?) {
        guard let spotData = spotData else { return nil }
        self.spotData = spotData
        
        locationFecher.locationPublisher().sink { [weak self] _ in
            guard let self = self else { return }
            self.updateValues()
        }.store(in: &cancellables)
    }
    
    func updateValues() {
        if let lastLocation = locationFecher.lastKnownLocation {
            distance = spotData.distance(from: lastLocation)
            if let lastHeading = locationFecher.lastKnownHeading {
                angle = Double(lastLocation.angle(target: spotData.location)) - lastHeading.magneticHeading
            }
        }
    }
}
