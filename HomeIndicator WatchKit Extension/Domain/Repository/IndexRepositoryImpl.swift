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
    private let userDefaults = UserDefaults.standard
    
    func get() -> Int {
        userDefaults.integer(forKey: Self.key)
    }
    
    func set(_ index: Int) {
        userDefaults.set(index, forKey: Self.key)
    }
}
