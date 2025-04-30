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
    @AppStorage("userEmail") private var userEmail: String = ""
    @State private var isSuccess = false
    @Environment(\.dismiss) private var dismiss
    @State private var animateCheck = false
    @Binding var BadmintonDailyCount: Int
    @Binding var needRefresh: Bool
    @MainActor
    private func confirmBooking() async {
        do {
            try await client
                .from("badminton_court1")
                .update(["availability": "occupied", "user": userEmail])
                .eq("time", value: time)
                .execute()
            
            // Ignore response details, mark success directly
            isSuccess = true
            BadmintonDailyCount += 1
            needRefresh = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                needRefresh = false
            }
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
    BadmintonConfirmation(time: .constant(900), BadmintonDailyCount: .constant(1), needRefresh: .constant(false))
}
