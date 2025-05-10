//
//  BadmintonCancellation.swift
//  VenuePass
//
//  Created by Bruce Zheng on 5/1/25.
//
import SwiftUI

struct BadmintonCancellation: View {
    @Binding var time: Int
    @State private var isSuccess = false
    @Environment(\.dismiss) private var dismiss
    @State private var animateCheck = false
    @Binding var BadmintonDailyCount: Int
    @Binding var needRefresh: Bool
    @Binding var number: Int
    @MainActor
    private func cancelBooking() async {
        do {
            try await client
                .from("badminton_court\(number)")
                .update(["availability": "free", "user": ""])
                .eq("time", value: time)
                .execute()
            
            // Ignore response details, mark success directly
            isSuccess = true
            BadmintonDailyCount -= 1
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
            
            Text("确定要取消此时段吗？")
                .bold()
                .font(.system(size: 30))
            
            Button {
                Task {
                    await cancelBooking()
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
    BadmintonCancellation(time: .constant(900), BadmintonDailyCount: .constant(1), needRefresh: .constant(false), number: .constant(1))
}
