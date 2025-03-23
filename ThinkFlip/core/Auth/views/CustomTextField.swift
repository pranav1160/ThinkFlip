//
//  CustomTextField.swift
//  ThinkFlip
//
//  Created by Pranav on 23/03/25.
//


import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: Text
    let imgName:String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .foregroundColor(Color.white.opacity(0.7))
                    .padding(.leading, 45) // Adjust for icon spacing
            }
            
            HStack(spacing: 12) {
                Image(systemName: imgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white.opacity(0.8))
                
                TextField("", text: $text)
                    .foregroundColor(.white)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding(12)
            .background(Color.white.opacity(0.15)) // ✅ Apply background here
            .clipShape(RoundedRectangle(cornerRadius: 12)) // ✅ Rounded rectangle
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1) // ✅ Thin border
            )
        }
        .padding(.horizontal) // Add padding for cleaner layout
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea() // Dark background for contrast
        CustomTextField(
            text: .constant(""),
            placeholder: Text("Email"),
            imgName: "wind"
        )
            .padding()
    }
}
