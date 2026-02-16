//
//  SpotRegisiterViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import CoreLocation
import MapKit

@MainActor
class SpotRegisiterViewModel: ObservableObject {
    
    @Published var mapRegion: MKCoordinateRegion
    
    private let spotRepository: SpotRepository
    
    init(spotRepositroy: SpotRepository = SpotRepositoryImpl()) {
        self.spotRepository = spotRepositroy
        let coordinate = LocationFetcher.shared.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D()
        mapRegion = MKCoordinateRegion(center: coordinate, span: .init())
    }
    
    func registerButtonTapped(name: String, coordinates: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let spotData = SpotData(name: name, location: location)
        spotRepository.save(spotData)
    }
}
