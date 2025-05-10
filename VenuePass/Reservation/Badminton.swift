//
//  Badminton.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/29/25.
//

import SwiftUI
import Supabase

struct BadmintonData: Decodable, Identifiable {
    var id: Int { time }          // ForEach 键
    let time: Int                 // 800 / 830 / …
    var availability: String     // true / false / nil
    let user: String?
}

struct CourtSlotView: View {
    let slot: BadmintonData
    @Binding var BadmintonDailyCount: Int
    @Binding var needRefresh: Bool
    let courtNumber: Int
    @AppStorage("userEmail") private var userEmail: String = ""
    private var backgroundColor: Color {
        if slot.availability == "free" {
            return Color.green.opacity(0.6)
        } else if slot.availability == "occupied" {
            if let user = slot.user, user == userEmail {
                return Color.blue.opacity(0.3)
            } else {
                return Color.red.opacity(0.6)
            }
        } else if slot.availability == "notopen" {
            return Color.gray.opacity(0.3)
        } else {
            return Color.gray.opacity(0.3)
        }
    }
    
    @State private var showConfirmation = false
    
    var body: some View {
        VStack {
            Text("\(slot.time / 100):\(String(format: "%02d", slot.time % 100))")
                .bold()
                .foregroundStyle(.white)
            if let user = slot.user, user == userEmail && slot.availability == "occupied" {
                Text("已预定")
                    .bold()
                    .foregroundStyle(.white)
            } else if slot.availability == "occupied" {
                Text("已满")
                    .bold()
                    .foregroundStyle(.white)
            } else if slot.availability == "free" {
                Text("空闲")
                    .bold()
                    .foregroundStyle(.white)
            } else if slot.availability == "notopen" {
                Text("未开放")
                    .bold()
                    .foregroundStyle(.white)
            }
        }
        .onTapGesture {
            if slot.availability == "free" && BadmintonDailyCount <= 2 {
                showConfirmation = true
            }
        }
        .frame(width: 90, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(backgroundColor)
        )
        .sheet(isPresented: $showConfirmation) {
            BadmintonConfirmation(time: .constant(slot.time), BadmintonDailyCount: $BadmintonDailyCount, needRefresh: $needRefresh, courtNumber: courtNumber)
                .presentationDetents([.height(400)])
        }
    }
}

func fetchCourt(courtNumber: Int) async throws -> [BadmintonData] {
    try await client
        .from("badminton_court\(courtNumber)")
        .select()
        .order("time")
        .execute()
        .value
}

struct Badminton: View {
    @State private var row1: [BadmintonData] = []
    @State private var row2: [BadmintonData] = []
    @State private var row3: [BadmintonData] = []
    @State private var row4: [BadmintonData] = []
    @Binding var BadmintonDailyCount: Int
    @State var needRefresh = false
    private var allLoaded: Bool {
        !row1.isEmpty && !row2.isEmpty && !row3.isEmpty && !row4.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            if !allLoaded {
                ProgressView("加载中...")
                    .scaleEffect(1)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .center, spacing: 10) {
                        HStack(alignment: .top) {
                            VStack {
                                Text("1号")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                ForEach(row1) { CourtSlotView(slot: $0, BadmintonDailyCount: $BadmintonDailyCount, needRefresh: $needRefresh, courtNumber: 1) }
                            }
                            VStack {
                                Text("2号")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                ForEach(row2) { CourtSlotView(slot: $0, BadmintonDailyCount: $BadmintonDailyCount, needRefresh: $needRefresh, courtNumber: 2) }
                            }
                            VStack {
                                Text("3号")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                ForEach(row3) { CourtSlotView(slot: $0, BadmintonDailyCount: $BadmintonDailyCount, needRefresh: $needRefresh, courtNumber: 3) }
                            }
                            VStack {
                                Text("4号")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                ForEach(row4) { CourtSlotView(slot: $0, BadmintonDailyCount: $BadmintonDailyCount, needRefresh: $needRefresh, courtNumber: 4) }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle(BadmintonDailyCount != 0
                    ? "羽毛球(\(BadmintonDailyCount))"
                    : "羽毛球")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .refreshable {
            await loadAll()
        }
        .scrollIndicators(.hidden)
        .task {
            await loadAll()
            if needRefresh {
                await loadAll()
            }
        }
        .onChange(of: needRefresh) { newValue in
            if newValue {
                Task { await loadAll() }
                needRefresh = false
            }
        }
    }
    @MainActor
        func loadAll() async {
            do {
                async let d1 = fetchCourt(courtNumber: 1)
                async let d2 = fetchCourt(courtNumber: 2)
                async let d3 = fetchCourt(courtNumber: 3)
                async let d4 = fetchCourt(courtNumber: 4)
                let (r1, r2, r3, r4) = try await (d1, d2, d3, d4)
                row1 = r1; row2 = r2; row3 = r3; row4 = r4
            } catch {
                print("Fetch error:", error)
            }
        }
    }



#Preview {
    Badminton(BadmintonDailyCount: .constant(1))
}
