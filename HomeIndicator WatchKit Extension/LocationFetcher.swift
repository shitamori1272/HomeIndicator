//
//  LocationFetcher.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2020/08/09.
//  Copyright © 2020 Shitamori. All rights reserved.
//

import CoreLocation
import Combine
import ClockKit
import WidgetKit

@MainActor
class LocationFetcher: NSObject, @preconcurrency CLLocationManagerDelegate, ObservableObject, LocationProvider {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocation?
    var lastKnownHeading: CLHeading?
    
    private var isStarted = false
    
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
        didUpdateCLLocation()
        locationSubject.send(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastKnownHeading = newHeading
        didUpdateCLLocation()
        locationSubject.send(true)
    }
    
    func didUpdateCLLocation() {
        let complicationServer = CLKComplicationServer.sharedInstance()
        complicationServer.activeComplications?.forEach {
            complicationServer.reloadTimeline(for: $0)
        }
        ComplicationSharedStore().reloadWidgetTimeline()
    }
}

@MainActor
protocol LocationProvider: ObservableObject {
    var lastKnownLocation: CLLocation? { get set }
    var lastKnownHeading: CLHeading? { get set }
    func start()
}

extension LocationProvider {
    var angle: Double? { lastKnownHeading?.magneticHeading }
}

@MainActor
class MockLocationProvider: LocationProvider {
    var lastKnownLocation: CLLocation?
    
    var lastKnownHeading: CLHeading?
    
    var angle: Double? = 0
    
    func start() {
        lastKnownLocation = CLLocation(latitude: 35.7142366, longitude: 139.8214326)
        lastKnownHeading = CLHeading()
        Timer.scheduledTimer(timeInterval: 1,
                             target: self,
                             selector: #selector(MockLocationProvider.timerUpdate),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func timerUpdate() {
        angle = (angle ?? 0) + 1
        if let lastLocation = lastKnownLocation {
            lastKnownLocation = CLLocation(latitude: lastLocation.coordinate.latitude + 0.000001, longitude: lastLocation.coordinate.longitude)
        }
    }
}
