//
//  PasswordRequirementView.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/28/25.
//

import SwiftUI

struct PasswordRequirementView: View {
    @Binding var isShowing: Bool
    var body: some View {
        HStack {
            Image(systemName:"xmark.circle.fill")
                .font(.caption)
                .foregroundStyle(.white)
            Text("密码不能为空")
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .shadow(color: .red, radius: 1.3)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isShowing = false
            }
        }
        
    }
}

#Preview {
    PasswordRequirementView(isShowing: .constant(true))
}

