//
//  BadmintonConfirmation.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/29/25.
//

import SwiftUI
import Supabase

struct BadmintonConfirmation: View {
    @Binding var time: Int
    @State var supabaseUserEmail: String? = nil
    @State private var isSuccess = false
    @Environment(\.dismiss) private var dismiss
    @State private var animateCheck = false
    @Binding var dailyCount: Int
    @MainActor
    private func confirmBooking() async {
        do {
            try await client
                .from("badminton_court1")
                .update(["availability": "occupied", "user": supabaseUserEmail])
                .eq("time", value: time)
                .execute()
            
            // Ignore response details, mark success directly
            isSuccess = true
            dailyCount += 1
        } catch {
            print("Unexpected error:", error)
        }
    }
    var body: some View {
        if isSuccess == false {
        VStack {
            Image(systemName: "figure.badminton")
                .resizable()
                .scaledToFit()
                .frame(width: 70)
            
            Text("\(time / 100):\(String(format: "%02d", time % 100))")
                .bold()
                .font(.system(size: 50))
            
            Text("确定要预订此时段吗？")
                .bold()
                .font(.system(size: 30))
            
            Button {
                Task {
                    await confirmBooking()
                }
            } label: {
                Text("确认")
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.vertical, 15)
                    .padding(.horizontal, 170)
                    .background(RoundedRectangle(cornerRadius: 20))
                
            }
            .task {
                do {
                    if let user = try await client.auth.currentUser {
                        supabaseUserEmail = user.email
                    } else {
                        supabaseUserEmail = nil
                    }
                } catch {
                    print("获取 Supabase 用户信息失败: \(error)")
                    supabaseUserEmail = nil
                }
            }
        }
        } else {
            ZStack {
                Rectangle()
                    .foregroundStyle(.green)
                    .ignoresSafeArea()
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(.white)
                    .scaleEffect(animateCheck ? 1 : 0)
            }
            .onAppear {
                withAnimation(.spring()) {
                    animateCheck = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        }

    }
    
}

#Preview {
    BadmintonConfirmation(time: .constant(900), dailyCount: .constant(1))
}
