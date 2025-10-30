//
//  ZanyaFirstApp.swift
//  ZanyaFirst
//
//  Created by Kimjaekyeong on 2023/07/18.
//

import SwiftUI

@main
struct ZanyaFirstApp: App {
    
    init() {
        // Launch Screen을 인위적으로 보여주기 위한 Delay
        Thread.sleep(forTimeInterval: 1)
    }
    
    @StateObject var lnManager: LocalNotificationManager = LocalNotificationManager()
    
    var body: some Scene {
        WindowGroup {
            OnBoardingView()
                .environmentObject(lnManager)
        }
    }
}
