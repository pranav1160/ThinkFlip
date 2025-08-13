//
//  ProminentTextField.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//


import SwiftUI

struct ProminentTextField: View {
    enum Kind { case plain, secure }
    
    @Binding var text: String
    let title: String
    var systemImage: String = "person.fill"
    var keyboard: UIKeyboardType = .default
    var kind: Kind = .plain
    var error: String? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
                Group {
                    if kind == .secure {
                        SecureField(title, text: $text)
                            .textContentType(.password)
                    } else {
                        TextField(title, text: $text)
                            .textContentType(.name)
                            .keyboardType(keyboard)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.none)
                    }
                }
                .focused($isFocused)
                .submitLabel(.done)
                
                // Clear button
                if !text.isEmpty {
                    Button {
                        text.removeAll()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.medium)
                            .foregroundStyle(.secondary)
                            .opacity(0.8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.background)
                    .shadow(radius: isFocused ? 10 : 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(isFocused ? .pink : .secondary.opacity(0.25), lineWidth: isFocused ? 2 : 1)
            )
            .overlay(
                // subtle focus glow
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.blue.opacity(isFocused ? 0.07 : 0))
            )
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
            .animation(.smooth(duration: 0.15), value: isFocused)
            
            if let error, !error.isEmpty {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 4)
                    .transition(.opacity)
            }
        }
    }
}


#Preview{
    VStack{
        ProminentTextField(text: .constant("Hello"), title: "")
    }
}
