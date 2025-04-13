import SwiftUI

struct LoginView: View {
    @State private var emailTxt: String = ""
    @State private var passwdTxt: String = ""
    @State private var showAlert = false
    @State private var isEmailValid = true
    
    @ObservedObject var authVm: AuthViewModel
    
    private func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailTxt)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    Image(.logo)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(.circle)
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        CustomTextField(
                            text: $emailTxt,
                            placeholder: Text("Email"),
                            imgName: "envelope", isSecure: false
                        )
                        .onChange(of: emailTxt) { _ in
                            isEmailValid = true // Reset validation on change
                        }
                        
                        if !isEmailValid {
                            Text("Please enter a valid email")
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 40)
                        }
                    }
                    .padding(.bottom)
                    
                    CustomTextField(
                        text: $passwdTxt,
                        placeholder: Text("Password"),
                        imgName: "lock",
                        isSecure: true
                    )
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            // Forgot password functionality
                        } label: {
                            Text("Forgot password")
                                .foregroundStyle(.white)
                                .font(.footnote)
                                .bold()
                        }
                        .padding()
                    }
                    
                    Button {
                        // Validate email format
                        isEmailValid = validateEmail()
                        
                        if isEmailValid {
                            authVm.login(email: emailTxt, password: passwdTxt)
                        }
                    } label: {
                        if authVm.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .myBlue))
                                .frame(width: 320, height: 40)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 20))
                                .shadow(radius: 4)
                        } else {
                            Text("Sign In")
                                .frame(width: 320, height: 40)
                                .background(.white)
                                .foregroundStyle(.myBlue)
                                .clipShape(.rect(cornerRadius: 20))
                                .shadow(radius: 4)
                        }
                    }
                    .disabled(authVm.isLoading)
                    .onChange(of: authVm.errorMessage) { newError in
                        if let error = newError, !error.isEmpty {
                            showAlert = true
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        RegistrationView()
                            .environmentObject(authVm)
                    } label: {
                        Text("Don't have an account? Sign Up")
                            .bold()
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Failed"),
                message: Text(authVm.errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK")) {
                    // Optional: Clear password on failed login
                    if authVm.errorMessage?.contains("password") ?? false {
                        passwdTxt = ""
                    }
                }
            )
        }
    }
}

#Preview {
    LoginView(authVm: AuthViewModel())
}
