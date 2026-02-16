//
//  ContentViewModel.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/12/05.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import Foundation
import CoreGraphics
import Combine

protocol ContentViewModelProtocol: ObservableObject {
    
    var angle: CGFloat { get set }
    
    var distance: CGFloat { get set }
    
    var spotName: String { get }
    
    var shouldShowRegisterButton: Bool { get }
    
    func onAppear()
}

class ContentViewModel: ContentViewModelProtocol {
    
    let locationFetcher = LocationFetcher.shared
    
    @Published var angle: CGFloat = 0
    @Published var distance: CGFloat = 0
    var shouldShowRegisterButton: Bool { spotData == nil }
    var spotName: String {
        spotData?.name ?? NSLocalizedString(
            "content.spot_not_set",
            tableName: nil,
            bundle: .main,
            value: "スポット未設定",
            comment: ""
        )
    }
    var cancellables = Set<AnyCancellable>()
    
    @Published var spotData: SpotData?
    private let spotRepository: SpotRepository
    private let indexRepository: IndexRepository
    
    init(
        spotRepository: SpotRepository = SpotRepositoryImpl(),
        indexRepository: IndexRepository = IndexRepositoryImpl()
    ) {
        self.spotRepository = spotRepository
        self.indexRepository = indexRepository
        
        updateAngleAndDistance()
        
        locationFetcher.locationPublisher().sink { [weak self] _ in
            guard let self = self else { return }
            self.updateAngleAndDistance()
        }.store(in: &cancellables)
    }
    
    func updateAngleAndDistance() {
        guard let lastLocation = locationFetcher.lastKnownLocation,
              let lastHeading = locationFetcher.lastKnownHeading,
              let spotData = spotData else { return }
        let rawAngle = lastLocation.angle(target: spotData.location) - Float(lastHeading.magneticHeading)
        angle = CGFloat(rawAngle.normalizedArrowAngle())
        distance = spotData.distance(from: lastLocation)
    }
    
    func onAppear() {
        let index = indexRepository.get()
        let spotDataList = spotRepository.findAll()
        if spotDataList.indices.contains(index) {
            spotData = spotDataList[index]
        }
    }
}
