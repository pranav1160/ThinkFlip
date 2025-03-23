//
//  RegistrationView.swift
//  ThinkFlip
//
//  Created by Pranav on 23/03/25.
//


import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authVm:AuthViewModel
    @State private var userName:String=""
    @State private var emailTxt:String=""
    @State private var passwdTxt:String=""
    
    
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
                        text: $userName,
                        placeholder: Text("UserName"),
                        imgName: "person"
                    ).padding(.bottom)
                    
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
                        
                        authVm
                            .register(
                                username: userName,
                                email: emailTxt,
                                password: passwdTxt
                            )
                        
                    }label: {
                        Text("Sign Up")
                            .frame(width: 320,height: 40)
                            .background(.white)
                            .foregroundStyle(.myBlue)
                            .clipShape(.rect(cornerRadius: 20))
                            .shadow(radius: 4)
                    }
                    
                    
                    Spacer()
                    
//                    NavigationLink{
//                        LoginView(authVm: AuthViewModel())
//                    }label: {
//                        
//                        Text("Already have an account? Sign In")
//                            .bold()
//                            .foregroundStyle(.white)
//                        
//                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    RegistrationView()
}
