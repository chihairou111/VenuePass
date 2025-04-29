//
//  HomeView.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/25/25.
//

import SwiftUI


struct HomeView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showSheet = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    BadmintonWidget()
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
    }
    

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
