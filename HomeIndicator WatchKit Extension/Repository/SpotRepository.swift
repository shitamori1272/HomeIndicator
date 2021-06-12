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

class SpotRepository: SpotRepositoryProtocol {
    
    private static let key = "spotDataList"
    private let userDefaults = UserDefaults.standard

    func save(_ spot: SpotData) {
        var dataList = loadSpotDataList()
        dataList.append(spot)
        _ = saveSpotDataList(dataList)
    }

    func find(uuid: UUID) -> SpotData? {
        return loadSpotDataList().first(where: { $0.id == uuid })
    }

    func update(_ spot: SpotData, uuid: UUID) -> Bool {
        var dataList = loadSpotDataList()
        guard let index = dataList.firstIndex(where: { $0.id == uuid } ) else { return false }
        dataList[index] = spot
        let result = saveSpotDataList(dataList)
        return result
    }

    func delete(uuid: UUID) -> Bool {
        var dataList = loadSpotDataList()
        guard let index = dataList.firstIndex(where: { $0.id == uuid } ) else { return false }
        dataList.remove(at: index)
        let result = saveSpotDataList(dataList)
        return result
    }

    func findAll() -> [SpotData] {
        return loadSpotDataList()
    }
    
    private func loadSpotDataList() -> [SpotData] {
        guard let data = userDefaults.data(forKey: Self.key),
              let list = try? JSONDecoder().decode([SpotData].self, from: data) else { return [] }
        return list
    }
    
    private func saveSpotDataList(_ dataList: [SpotData]) -> Bool {
        guard let data = try? JSONEncoder().encode(dataList) else {
            return false
        }
        userDefaults.set(data, forKey: Self.key)
        return true
    }
}
