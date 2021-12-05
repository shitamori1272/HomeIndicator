//
//  SpotRegisiterUsecase.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import CoreLocation

class SpotRegisiterUsecase {
    
    private let repository = SpotRepositoryImpl()
    
    func handle(name: String, location: CLLocation) {
        let spot = SpotData(name: name, location: location)
        repository.save(spot)
    }
    
    func handle(name: String, coordinates: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        handle(name: name, location: location)
    }
}
