//
//  LoginSuccessView.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/28/25.
//

import SwiftUI

struct LoginSuccessView: View {
    @Binding var isShowing: Bool
    var body: some View {
        HStack {
            Image(systemName:"checkmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.white)
            Text("登录成功")
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(Color.green)
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .shadow(color: .green, radius: 1.3)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isShowing = false
            }
        }
        
    }
}

#Preview {
    LoginSuccessView(isShowing: .constant(true))
}

