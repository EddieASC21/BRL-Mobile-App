//  LoginView.swift
import SwiftUI

struct LoginView: View {
    // MARK: State
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var loginAlert: LoginAlert?
    #if DEBUG
    @State private var showDebugSheet = false
    #endif
    
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 20) {
                    Text("Welcome Back")
                        .font(.largeTitle).bold()
                    
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    
                    Button {
                        print("Button tapped")
                        Task { await login() }
                    } label: {
                        ZStack {
                            Text("Login")
                                .opacity(isLoading ? 0 : 1)
                                .frame(maxWidth: .infinity)
                                .padding()
                            if isLoading { ProgressView() }
                        }
                        .background(isFormValid ? Color.accentColor : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .disabled(!isFormValid || isLoading)
                }
                .padding(.horizontal)
                .padding(.top, 40)          // ←  move everything upward
                
                Spacer()                     // bottom spacer only
            }
            .alert(item: $loginAlert) { alert in
                Alert(title: Text(alert.message))
            }
            #if DEBUG
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showDebugSheet = true } label: {
                        Image(systemName: "wrench.fill")
                    }
                }
            }
            .sheet(isPresented: $showDebugSheet) {
                DebugTokenView()
            }
            #endif
        }
    }
    
    // MARK: Helpers
    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        email.contains("@") &&
        !password.isEmpty
    }
    
    @MainActor
    private func login() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await authService.login(email: email, password: password)
            loginAlert = LoginAlert(message: "Logged in ✔︎")
        } catch {
            loginAlert = LoginAlert(message: error.localizedDescription)
        }
    }
}

private struct LoginAlert: Identifiable {
    let id = UUID()
    let message: String
}
