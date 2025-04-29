//
//  VenuePassApp.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/25/25.
//

import SwiftUI






@main
struct VenuePassApp: App {
    @AppStorage("dailyCount") private var dailyCount: Int = 0
    @AppStorage("lastResetDate") private var lastResetDate: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    init() {
           resetIfNeeded()
       }
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView(dailyCount: $dailyCount)
            } else {
                LoginView()
            }


        }
    }
    private func resetIfNeeded() {
            // 1. 生成今天的日期字符串
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let today = formatter.string(from: Date())

            // 2. 如果上次重置不是今天，就清零并记录新日期
            if lastResetDate != today {
                dailyCount = 0
                lastResetDate = today
            }
        }
}
