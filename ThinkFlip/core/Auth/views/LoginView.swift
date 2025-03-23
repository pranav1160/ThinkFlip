//
//  LoginView.swift
//  ThinkFlip
//
//  Created by Pranav on 23/03/25.
//


import SwiftUI

struct LoginView: View {
    @State private var emailTxt:String=""
    @State private var passwdTxt:String=""
    
    @ObservedObject var authVm:AuthViewModel
    
    var body: some View {
        NavigationStack {
            
            ZStack{
                Color.black
                    .ignoresSafeArea()
                
                VStack{
                    Image(.logo)
                        .resizable()
                        .frame(width: 200,height: 200)
                        .clipShape(.circle)
                    
                    Spacer()
                    
                    CustomTextField(
                        text: $emailTxt,
                        placeholder: Text("Email"),
                        imgName: "envelope"
                    ).padding(.bottom)
                    
                    CustomTextField(
                        text: $passwdTxt,
                        placeholder: Text("Password"),
                        imgName: "lock"
                    )
                    
                    HStack {
                        
                        Spacer()
                        
                        Button{
                            
                        }label: {
                            
                            Text("Forgot password")
                                .foregroundStyle(.white)
                                .font(.footnote)
                                .bold()
                            
                        }
                        .padding()
                        
                        
                    }
                    
                    Button{
                        authVm.login(email: emailTxt, password: passwdTxt)
                    }label: {
                        Text("Sign In")
                            .frame(width: 320,height: 40)
                            .background(.white)
                            .foregroundStyle(.myBlue)
                            .clipShape(.rect(cornerRadius: 20))
                            .shadow(radius: 4)
                    }
                    
                    
                    Spacer()
                    
                    NavigationLink{
                        RegistrationView()
                            .environmentObject(authVm)
                    }label: {
                        
                        Text("Dont have an account? Sign Up")
                            .bold()
                            .foregroundStyle(.white)
                        
                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    LoginView(authVm: AuthViewModel())
}
