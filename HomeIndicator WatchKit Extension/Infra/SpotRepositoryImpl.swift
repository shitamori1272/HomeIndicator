//
//  SpotRepositoryImpl.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

class SpotRepositoryImpl: SpotRepositoryProtocol {
    
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
    
    func getIndex() -> Int {
        userDefaults.integer(forKey: "spotIndex")
    }
    
    func setIndex(index: Int) {
        userDefaults.set(index, forKey: "spotIndex")
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
