//
//  SpotRepository.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/05/15.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

protocol SpotRepositoryProtocol {
    
    func save(_ spot: SpotData)
    
    func find(uuid: UUID) -> SpotData?
    
    func update(_ spot: SpotData, uuid: UUID) -> Bool
    
    func delete(uuid: UUID) -> Bool
    
    func findAll() -> [SpotData]
}
