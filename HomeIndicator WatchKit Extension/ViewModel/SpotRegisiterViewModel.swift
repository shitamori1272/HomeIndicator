//
//  SpotRegisiterViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import CoreLocation

class SpotRegisiterViewModel: ObservableObject {
    
    private let spotRepository: SpotRepository
    
    init(spotRepositroy: SpotRepository = SpotRepositoryImpl()) {
        self.spotRepository = spotRepositroy
    }
    
    func registerButtonTapped(name: String, coordinates: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let spotData = SpotData(name: name, location: location)
        spotRepository.save(spotData)
    }
}
