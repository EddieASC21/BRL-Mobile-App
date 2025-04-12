//  DebugTokenView.swift
import SwiftUI

struct DebugTokenView: View {
    @State private var tokenSnippet: String?
    @State private var pingResult: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                GroupBox("Keychain") {
                    VStack {
                        if let snippet = tokenSnippet {
                            Text("Token prefix:")
                            Text(snippet).font(.footnote).monospaced()
                        } else {
                            Text("No token in Keychain")
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                
                HStack {
                    Button("Load from Keychain") {
                        if let t = TokenManager.shared.getToken() {
                            tokenSnippet = String(t.prefix(20)) + "…"
                        } else {
                            tokenSnippet = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Clear") {
                        try? TokenManager.shared.clearToken()
                        tokenSnippet = nil
                    }
                }
                
                Divider().padding(.vertical, 4)
                
                Button("Ping API") {
                    Task {
                        do {
                            try await DemoAPIService.ping()
                            pingResult = "200 OK"
                        } catch {
                            pingResult = "🔴 \(error.localizedDescription)"
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if let ping = pingResult {
                    Text(ping).monospaced()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Debug Tools")
        }
    }
}
