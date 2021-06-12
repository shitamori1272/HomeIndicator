//
//  CLLocation+angle.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/05/30.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    
    var text: String {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        return "\(lat), \(lon)"
    }
    
    func angle(target: CLLocation) -> Float {
        func toRadian(_ angle: CLLocationDegrees) -> Float { Float(angle) * Float.pi / 180 }
        
        let currentLatitude     = toRadian(coordinate.latitude)
        let currentLongitude    = toRadian(coordinate.longitude)
        let targetLatitude      = toRadian(target.coordinate.latitude)
        let targetLongitude     = toRadian(target.coordinate.longitude)
        
        let difLongitude = targetLongitude - currentLongitude
        let y = sin(difLongitude)
        let x = cos(currentLatitude) * tan(targetLatitude) - sin(currentLatitude) * cos(difLongitude)
        let p = atan2(y, x) * 180 / Float.pi
        
        if p < 0 {
            return 360 + atan2(y, x) * 180 / Float.pi
        }
        return atan2(y, x) * 180 / Float.pi
    }
}
