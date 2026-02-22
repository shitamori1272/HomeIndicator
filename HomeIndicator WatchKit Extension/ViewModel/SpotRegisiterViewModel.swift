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
    private let locationProvider: any LocationProvider
    
    init(
        spotRepositroy: SpotRepository = SpotRepositoryImpl(),
        locationProvider: any LocationProvider = LocationFetcher.shared
    ) {
        self.spotRepository = spotRepositroy
        self.locationProvider = locationProvider
        locationProvider.start()
        let coordinate = locationProvider.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D()
        mapRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
    
    func registerButtonTapped(name: String, coordinates: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let spotData = SpotData(name: name, location: location)
        spotRepository.save(spotData)
    }
}
