//
//  BadmintonWidget.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/25/25.
//

import SwiftUI
import Supabase

struct BadmintonWidget: View {
    @Binding var availableCount: Int
    @Binding var dailyCount: Int
    var body: some View {
        NavigationStack {
            NavigationLink(destination: Badminton(dailyCount: $dailyCount)) {
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
                        
                        Text("今日有\(availableCount)空闲时段")
                            .foregroundStyle(.blue)
                            .font(.system(size: 15))
                    }
                    .padding()
                }
                .frame(width: 380, height: 100)
                .background(Color.blue.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius:20))
            }
        }
    }
        
    
}

#Preview {
    BadmintonWidget(availableCount: .constant(3), dailyCount: .constant(1))
}
