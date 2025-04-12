import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var alertMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()

    func login() {
        // check for empty fields
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both an email and a password."
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        AuthService.shared.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { token in
                // TODO: store the access token using Keychain
                print("Access Token: \(token)")
            }
            .store(in: &cancellables)
    }
}
