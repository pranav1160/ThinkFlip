import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authVm: AuthViewModel
    @State private var userName: String = ""
    @State private var emailTxt: String = ""
    @State private var passwdTxt: String = ""
    @State private var confirmPasswdTxt: String = ""
    @State private var showAlert = false
    @State private var isEmailValid = true
    @State private var isUsernameValid = true
    @State private var isPasswordValid = true
    @State private var passwordsMatch = true
    @Environment(\.dismiss) private var dismiss
    
    private func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTxt.isEmpty ? false : emailPred.evaluate(with: emailTxt)
    }
    
    private func validateUsername() -> Bool {
        return userName.count >= 3
    }
    
    private func validatePassword() -> Bool {
        return passwdTxt.count >= 6
    }
    
    private func validatePasswordsMatch() -> Bool {
        return passwdTxt == confirmPasswdTxt
    }
    
    private func validateForm() -> Bool {
        isUsernameValid = validateUsername()
        isEmailValid = validateEmail()
        isPasswordValid = validatePassword()
        passwordsMatch = validatePasswordsMatch()
        
        return isUsernameValid && isEmailValid && isPasswordValid && passwordsMatch
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image(.logo)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .padding(.top, 30)
                        
                        Text("Create Account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        VStack(spacing: 5) {
                            CustomTextField(
                                text: $userName,
                                placeholder: Text("Username"),
                                imgName: "person",
                                isSecure: false
                            )
                            .onChange(of: userName) { _ in
                                isUsernameValid = true
                            }
                            
                            if !isUsernameValid {
                                Text("Username must be at least 3 characters")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 40)
                            }
                        }
                        
                        VStack(spacing: 5) {
                            CustomTextField(
                                text: $emailTxt,
                                placeholder: Text("Email"),
                                imgName: "envelope",
                                isSecure: false
                            )
                            .onChange(of: emailTxt) { _ in
                                isEmailValid = true
                            }
                            
                            if !isEmailValid {
                                Text("Please enter a valid email address")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 40)
                            }
                        }
                        
                        VStack(spacing: 5) {
                            CustomTextField(
                                text: $passwdTxt,
                                placeholder: Text("Password"),
                                imgName: "lock",
                                isSecure: false
                            )
                            .onChange(of: passwdTxt) { _ in
                                isPasswordValid = true
                                passwordsMatch = true
                            }
                            
                            if !isPasswordValid {
                                Text("Password must be at least 6 characters")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 40)
                            }
                        }
                        
                        VStack(spacing: 5) {
                            CustomTextField(
                                text: $confirmPasswdTxt,
                                placeholder: Text("Confirm Password"),
                                imgName: "lock.shield",
                                isSecure: true
                            )
                            .onChange(of: confirmPasswdTxt) { _ in
                                passwordsMatch = true
                            }
                            
                            if !passwordsMatch {
                                Text("Passwords do not match")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 40)
                            }
                        }
                        
                        Button {
                            // Validate all fields before registration
                            if validateForm() {
                                authVm.register(
                                    username: userName,
                                    email: emailTxt,
                                    password: passwdTxt
                                )
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
                                Text("Sign Up")
                                    .frame(width: 320, height: 40)
                                    .background(.white)
                                    .foregroundStyle(.myBlue)
                                    .clipShape(.rect(cornerRadius: 20))
                                    .shadow(radius: 4)
                            }
                        }
                        .disabled(authVm.isLoading)
                        .padding(.top, 20)
                        .onChange(of: authVm.isAuthenticated) { isAuthenticated in
                            if isAuthenticated {
                                // Successful registration, navigate back or to home
                                dismiss()
                            }
                        }
                        .onChange(of: authVm.errorMessage) { newError in
                            if let error = newError, !error.isEmpty {
                                showAlert = true
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Text("Already have an account? Sign In")
                                .bold()
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Registration Failed"),
                    message: Text(authVm.errorMessage ?? "An unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegistrationView().environmentObject(AuthViewModel())
}
