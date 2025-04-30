import SwiftUI
import Supabase

struct Settings: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userEmail") private var userEmail: String = ""

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
                                if !userEmail.isEmpty {
                                    Text("\(userEmail)")
                                } else {
                                    Text("未登录")
                                }

                                Text("一切都好！")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()


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
