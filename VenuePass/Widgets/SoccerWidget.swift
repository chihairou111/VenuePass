//
//  SoccerWidget.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/27/25.
//

import SwiftUI

struct SoccerWidget: View {
    var body: some View {
        HStack {
            //Image
            Image(systemName: "figure.soccer")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding()
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                
               
                
                
                Text("足球场")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.green)
                
                Text("今日有空闲场地")
                    .foregroundStyle(.green)
                    .font(.system(size: 15))
            }
            .padding()
        }
        .frame(width: 380, height: 100)
        .background(Color.green.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius:15))
    }
}

#Preview {
    SoccerWidget()
}
