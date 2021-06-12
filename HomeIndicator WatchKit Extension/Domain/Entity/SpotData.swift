//
//  File.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/05/16.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation
import CoreLocation

struct SpotData: Identifiable {
    var id = UUID()
    var name: String
    var updateDate = Date()
    let location: CLLocation
    var lat: CLLocationDegrees { location.coordinate.latitude }
    var lon: CLLocationDegrees { location.coordinate.longitude }
    
    init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
    }
    
    func angle(from: CLLocation) -> CLLocationDegrees {
       return CLLocationDegrees()
    }
    
    func distance(from: CLLocation) -> CLLocationDistance {
        location.distance(from: from)
    }
    
    static func createDataList() -> [SpotData] {
        let size = 4
        return (0..<size).map { SpotData(name: "spot\($0)", location: CLLocation(latitude: 35.160258, longitude: 136.959906 ))}
    }
}

extension SpotData: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, updateDate, lat, lon
      }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(UUID.self, forKey: .id)
        updateDate = try container.decode(Date.self, forKey: .updateDate)
        let lat = try container.decode(CLLocationDegrees.self, forKey: .lat)
        let lon = try container.decode(CLLocationDegrees.self, forKey: .lon)
        location = CLLocation(latitude: lat, longitude: lon)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(updateDate, forKey: .updateDate)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }
}



