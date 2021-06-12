//
//  ExtendedSessionManager.swift
//  HomeIndicator WatchKit Extension
//
//  Created by 下森周平 on 2021/06/12.
//  Copyright © 2021 Shitamori. All rights reserved.
//

import WatchKit

class ExtendedSessionManager: NSObject, ObservableObject {
    
    private var session: WKExtendedRuntimeSession?
    
    @Published var isRunning: Bool = false
        
    
    func startSession() {
        session?.invalidate()
        session = WKExtendedRuntimeSession()
        session?.delegate = self
        session?.start()
        updateRunningStatus()
    }
    
    func stopSession() {
        session?.invalidate()
        session = nil
        updateRunningStatus()
    }
    
    private func updateRunningStatus() {
        isRunning = session?.state == .running
    }
}


extension ExtendedSessionManager: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        updateRunningStatus()
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        updateRunningStatus()
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        updateRunningStatus()
    }
}
