import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("login")
                .font(.largeTitle)
                .bold()

            TextField("email", text: $viewModel.email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            
            if let emailError = viewModel.emailError {
                Text(emailError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            SecureField("password", text: $viewModel.password)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            
            if let passwordError = viewModel.passwordError {
                Text(passwordError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button(action: {
                viewModel.login()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Login")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            if let generalError = viewModel.generalError {
                Text(generalError)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top)
            }

            Spacer()
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("login error cuh"), message: Text(viewModel.generalError ?? "Unknown error"), dismissButton: .default(Text("OK")))
        }
    }
}
