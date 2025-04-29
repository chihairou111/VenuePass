import SwiftUI
import Supabase

struct Settings: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var supabaseUserEmail: String?

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    // account
                    Section {
                        HStack {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .foregroundStyle(.blue)

                            VStack(alignment: .leading) {
                                // email
                                if let email = supabaseUserEmail {
                                    Text("\(email)")
                                } else {
                                    Text("未登录")
                                }

                                Text("一切都好！")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
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

                        Button(role: .destructive) {
                            Task {
                                await logout()
                            }
                        } label: {
                            Text("Sign Out")
                        }
                    }
                }
            }
            .navigationTitle("设置")
        }
    }

    // MARK: - Logout Function
    func logout() async {
        do {
            try await client.auth.signOut()
            isLoggedIn = false
            print("成功登出 ✅")
        } catch {
            print("登出失败：\(error.localizedDescription)")
        }
    }
}

#Preview {
    Settings()
}
