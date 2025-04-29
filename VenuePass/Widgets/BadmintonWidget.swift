//
//  BadmintonWidget.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/25/25.
//

import SwiftUI
import Supabase

struct BadmintonWidget: View {
    @State private var availableCount = 0
    var body: some View {
        HStack {
            //Image
            Image(systemName: "figure.badminton")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.blue)
                .padding()
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                
               
                
                
                Text("羽毛球场")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.blue)
                
                Text("今日有\(availableCount)空闲场地")
                    .foregroundStyle(.blue)
                    .font(.system(size: 15))
                    .task { await fetchAvailableCount() }
            }
            .padding()
        }
        .frame(width: 380, height: 100)
        .background(Color.blue.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius:20))
    }
        
    func fetchAvailableCount() async {
            do {
                let rsp = try await client
                    .from("badminton_court1")
                    .select(head: true, count: .exact)   // 只要 count
                    .eq("availability", value: true)
                    .execute()
                availableCount = rsp.count ?? 0
            } catch {
                print(error)
                availableCount = 0
            }
        }
}

#Preview {
    BadmintonWidget()
}
