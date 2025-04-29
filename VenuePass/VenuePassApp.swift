//
//  VenuePassApp.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/25/25.
//

import SwiftUI






@main
struct VenuePassApp: App {

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var body: some Scene {
        WindowGroup {
//            if isLoggedIn {
//                HomeView()
//            } else {
//                LoginView()
//            }
//
            Badminton()
        }
    }
}
