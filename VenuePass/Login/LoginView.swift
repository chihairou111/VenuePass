//
//  LoginView.swift
//  VenuePass
//
//  Created by Bruce Zheng on 4/27/25.
//

import SwiftUI
import Auth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var needAnAccount = false
    @State private var showAccountErrorView = false
    @State private var showRegisterSuccessView = false
    @State private var showLoginSuccessView = false
    @State private var showEmailBadlyFormattedView = false
    @State private var showAccountExistsView = false
    @State private var showShortPasswordView = false
    @State private var showPasswordRequirementView = false

    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Image("loginview-templete")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                //Login Widget
                VStack {
                    Spacer()
                    
                    VStack(spacing: 15) {
                       //MARK: Sign In
                        if needAnAccount == false {
                            // Title
                            Text("请登录账号")
                                .font(.title2)
                                .bold()
                            
                            // Email Field
                            TextField("邮箱", text: $email)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                                .cornerRadius(30)
                            
                            // Password Field
                            SecureField("密码", text: $password)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                                .cornerRadius(30)
                            
                            HStack {
                                // Sign Up Button
                                Button(action: {
                                    needAnAccount = true
                                }) {
                                    Text("注册")
                                        .bold()
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color(.systemBackground))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.secondary, lineWidth: 1)
                                        )
                                        .foregroundStyle(Color.primary)
                                }
                                .padding(.horizontal, 5)
                                
                                // Login Button
                                Button(action: {
                                    Task {
                                        await login()
                                    }
                                }) {
                                    Text("登录")
                                        .bold()
                                        .frame(maxWidth: .infinity, minHeight: 50)
                                        .background(
                                            RoundedRectangle(cornerRadius: 30)
                                                .fill(Color.primary)
                                        )
                                        .foregroundStyle(Color(.systemBackground))
                                }
                                .padding(.horizontal, 5)
                            }
                            .onAppear {
                                email = ""
                                password = ""
                            }
                        } else {
                            //MARK: Sign Up
                            Text("注册账号")
                                .font(.title2)
                                .bold()
                            
                            TextField("邮箱", text: $email)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                                .cornerRadius(30)
                            
                            SecureField("密码", text: $password)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                                .cornerRadius(30)
                            
                            Button(action: {
                                Task {
                                    await register()
                                    if showRegisterSuccessView {
                                        needAnAccount = false
                                    }
                                }
                            }) {
                                Text("注册")
                                    .bold()
                                    .frame(maxWidth: .infinity, minHeight: 50)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color.primary)
                                    )
                                    .foregroundStyle(Color(.systemBackground))
                            }
                            .padding(.horizontal, 5)
                            .onAppear {
                                email = ""
                                password = ""
                            }
                        }
                    }
                    .padding(30)
                    .background(.background)
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
                }
                .frame(maxHeight: .infinity)
                
                VStack {
                    Spacer()
                    ZStack {
                        if showAccountErrorView {
                            AccountErrorView(isShowing: $showAccountErrorView)
                                .transition(.opacity)
                        }
                        if showRegisterSuccessView {
                            RegisterSuccessView(isShowing: $showRegisterSuccessView)
                                .transition(.opacity)
                        }
                        if showEmailBadlyFormattedView {
                            EmailBadlyFormattedView(isShowing: $showEmailBadlyFormattedView)
                                .transition(.opacity)
                        }
                        if showLoginSuccessView {
                            LoginSuccessView(isShowing: $showLoginSuccessView)
                                .transition(.opacity)
                        }
                        if showAccountExistsView {
                            AccountExistsView(isShowing: $showAccountExistsView)
                                .transition(.opacity)
                        }
                        if showShortPasswordView {
                            ShortPasswordView(isShowing: $showShortPasswordView)
                                .transition(.opacity)
                        }
                        if showPasswordRequirementView {
                            PasswordRequirementView(isShowing: $showPasswordRequirementView)
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut(duration: 0.1), value: showAccountErrorView)
                    .animation(.easeInOut(duration: 0.3), value: showRegisterSuccessView)
                    .animation(.easeInOut(duration: 0.3), value: showEmailBadlyFormattedView)
                    .animation(.easeInOut(duration: 0.3), value: showLoginSuccessView)
                    .animation(.easeInOut(duration: 0.3), value: showAccountExistsView)
                    .animation(.easeInOut(duration: 0.3), value: showShortPasswordView)
                    .animation(.easeInOut(duration: 0.3), value: showPasswordRequirementView)
                }
            }
            .navigationTitle("一站式场地预约系统")
        }
    }
    
    // MARK: - 登录
    func login() async {
        do {
            let result = try await client.auth.signIn(email: email, password: password)
            print("登录成功: \(result)")
            showLoginSuccessView = true // 显示登录成功视图
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isLoggedIn = true // 更新登录状态
            }
           
           
        } catch {
            print("登录失败: \(error)")
            if let authError = error as? AuthError {
                showAccountErrorView = true
            }
        }
    }
    
    // MARK: - 注册
//    func register() {
//        print("👉 register() tapped")
//        self.showAccountErrorView = false
//        self.showLoginSuccessView = false
//        self.showRegisterSuccessView = false
//        self.showEmailBadlyFormattedView = false
//        self.showAccountExistsView = false
//        
//        Auth.auth().createUser(withEmail: email, password: password) { _, err in
//            DispatchQueue.main.async {
//                if let err = err as NSError? {
//                    let code = err.code
//                    let description = err.localizedDescription
//                    let name = err.userInfo["FIRAuthErrorUserInfoNameKey"] as? String ?? "未知错误"
//                    
//                    print("🚨 注册错误代码: \(code)")
//                    print("🚨 注册错误名字: \(name)")
//                    print("🚨 注册错误描述: \(description)")
//                    
//                    switch code {
//                    case 17008, 17004: // invalidEmail or invalidCredential
//                        self.showEmailBadlyFormattedView = true
//                    case 17007: // Account Exists
//                        self.showAccountExistsView = true
//                    default:
//                        break
//                    }
//                } else {
//                    self.showRegisterSuccessView = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                        self.needAnAccount = false
//                    }
//                }
//            }
//        }
//    }
    func register() async {
        do {
            let result = try await client.auth.signUp(
                email: email,
                password: password
            )
            print("注册成功: \(result)")
            showRegisterSuccessView = true

        } catch {
            print("注册失败: \(error)")
            if let authError = error as? AuthError {
                print("捕获到的 AuthError: \(authError.message)") // 打印整个 AuthError 枚举值
                if authError.message == "Unable to validate email address: invalid format" { // Invalid Format
                    showEmailBadlyFormattedView = true
                } else if authError.message == "Password should be at least 6 characters." { // Short Password
                    showShortPasswordView = true
                } else if authError.message == "Signup requires a valid password" {
                    // Requires Password
                    showPasswordRequirementView = true
                }
                
            }
        }
    }
}

#Preview {
    LoginView()
}
