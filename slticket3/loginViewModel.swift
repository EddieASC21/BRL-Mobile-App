import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var generalError: String?
    @Published var showAlert = false
    @Published var isLoading = false

    func login() {
        emailError = nil
        passwordError = nil
        generalError = nil
        
        guard validate() else { return }
        
        isLoading = true
        
        //need a placeholder for auth call here
    }

    private func validate() -> Bool {
        var isValid = true
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            emailError = "email is required."
            isValid = false
        } else if !email.contains("@") {
            emailError = "enter a valid email."
            isValid = false
        }
        
        if password.isEmpty {
            passwordError = "password is required."
            isValid = false
        } else if password.count < 6 {
            passwordError = "password must be at least 6 characters."
            isValid = false
        }
        
        return isValid
    }
}


