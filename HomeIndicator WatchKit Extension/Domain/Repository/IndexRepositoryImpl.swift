//
//  IndexRepositoryImpl.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/06.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation

protocol IndexRepository {
    func get() -> Int
    func set(_ index: Int)
}

class IndexRepositoryImpl: IndexRepository {
    
    private static let key = "index"
    private static let legacyKey = "spotIndex"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func get() -> Int {
        if userDefaults.object(forKey: Self.key) != nil {
            return userDefaults.integer(forKey: Self.key)
        }
        guard userDefaults.object(forKey: Self.legacyKey) != nil else {
            return 0
        }
        let legacyValue = userDefaults.integer(forKey: Self.legacyKey)
        userDefaults.set(legacyValue, forKey: Self.key)
        userDefaults.removeObject(forKey: Self.legacyKey)
        return legacyValue
    }
    
    func set(_ index: Int) {
        userDefaults.set(index, forKey: Self.key)
        userDefaults.removeObject(forKey: Self.legacyKey)
    }
}
