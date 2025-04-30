//
//  HomeView.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/25/25.
//

// TODO: 封装fetch

import SwiftUI

struct HomeView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showSheet = false
    @State private var availableCount = 0
    @Binding var BadmintonDailyCount: Int
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    BadmintonWidget(availableCount: $availableCount, BadmintonDailyCount: $BadmintonDailyCount)
                    SoccerWidget()
                }
            }
            .padding()
            .navigationTitle("今天你要去哪里？")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showSheet) {
                Settings()
            }
        }
        .task { await fetchAvailableCount() }
        .refreshable {
            await fetchAvailableCount()
        }
    }
    
    func fetchAvailableCount() async {
            do {
                let rsp = try await client
                    .from("badminton_court1")
                    .select(head: true, count: .exact)   // 只要 count
                    .eq("availability", value: "free")
                    .execute()
                availableCount = rsp.count ?? 0
            } catch {
                print(error)
                availableCount = 0
            }
        }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(BadmintonDailyCount: .constant(1))
    }
}
