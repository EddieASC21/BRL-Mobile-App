//  BRLFrontendApp.swift
import SwiftUI

@main
struct BRLFrontendApp: App {
    @StateObject private var authService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(authService)
        }
    }
}
