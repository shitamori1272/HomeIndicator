//
//  LocationFetcher.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import CoreLocation
import Combine

@MainActor
class LocationFetcher: NSObject, @preconcurrency CLLocationManagerDelegate, ObservableObject, LocationProvider {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocation?
    var lastKnownHeading: CLHeading?
    
    private let locationSubject: PassthroughSubject<Bool, Never> = .init()

    static let shared = LocationFetcher()
    
    var angle: Double? { lastKnownHeading?.magneticHeading }

    private override init() {
        super.init()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        start()
    }
    
    func locationPublisher() -> AnyPublisher<Bool, Never> {
        return locationSubject.eraseToAnyPublisher()
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first
        locationSubject.send(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastKnownHeading = newHeading
        locationSubject.send(true)
    }
}

@MainActor
protocol LocationProvider: AnyObject {
    var lastKnownLocation: CLLocation? { get }
    var lastKnownHeading: CLHeading? { get }
    func locationPublisher() -> AnyPublisher<Bool, Never>
    func start()
}

extension LocationProvider {
    var angle: Double? { lastKnownHeading?.magneticHeading }
}

@MainActor
class MockLocationProvider: LocationProvider {
    private let locationSubject = PassthroughSubject<Bool, Never>()
    
    var lastKnownLocation: CLLocation?
    var lastKnownHeading: CLHeading?
    
    var angle: Double? = 0
    
    func start() {
        lastKnownLocation = CLLocation(latitude: 35.7142366, longitude: 139.8214326)
        locationSubject.send(true)
    }
    
    func locationPublisher() -> AnyPublisher<Bool, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    
    func update(location: CLLocation?, heading: CLHeading?) {
        lastKnownLocation = location
        lastKnownHeading = heading
        locationSubject.send(true)
    }
}
