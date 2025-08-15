//
//  ProfileEditView.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//


import SwiftUI
import PhotosUI

struct ProfileEditView: View {
    @AppStorage("userName") private var savedUserName: String = ""
    @AppStorage("userEmail") private var savedEmail: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempName: String = ""
    @State private var tempEmail: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: UIImage?
    
    var body: some View {
        
        ZStack {
            GradientBackground()
            VStack(spacing: 25) {
                
                // Profile Picture Picker
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        if let profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 8)

                        } else {
                            Image(.dissapointedBear)
                                .resizable()
                                .frame(width: 130, height: 130)
                                .clipShape(.circle)
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 8)
                                
                        }
                    }
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            profileImage = uiImage
                        }
                    }
                }
                
                // Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    TextField("Enter your name", text: $tempName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 5)
                }
                .padding(.horizontal)
                
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email Address")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    TextField("Enter your email", text: $tempEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.1), radius: 5)
                }
                .padding(.horizontal)
                
                // Save Button
                // Save Button
                Button(action: {
                    // Save name/email
                    savedUserName = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
                    savedEmail = tempEmail.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    // Save profile image
                    if let profileImage {
                        UserDefaults.standard.set(profileImage.jpegDataBase64, forKey: "profilePhoto")
                    }
                    
                    print("Saved profile: Name=\(savedUserName), Email=\(savedEmail)")
                    
                    dismiss()
                }) {
                    Text("Save Profile")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.vertical,50)

                Spacer()
            }
            .padding(.top, 40)
            .onAppear {
                // Load saved data into temporary state variables
                tempName = savedUserName
                tempEmail = savedEmail
                
                if let base64 = UserDefaults.standard.string(forKey: "profilePhoto"),
                   let image = UIImage.fromBase64(base64) {
                    profileImage = image
                }
            }
        }
        .navigationTitle("Edit Profile")
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
    }
}
