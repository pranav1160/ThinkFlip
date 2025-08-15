//
//  MainLibraryView.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//
import SwiftUI

struct MainLibraryView: View {
    var body: some View {
        ZStack {
            
            GradientBackground()
            
            VStack(spacing: 30) {
                NavigationLink {
                    CardLibraryView()
                } label: {
                    LibraryButton(title: "Saved Cards", icon: "rectangle.stack.fill")
                }
                
                NavigationLink {
                    QuizLibraryView()
                } label: {
                    LibraryButton(title: "Saved Quizzes", icon: "doc.text.fill")
                }
                
//                NavigationLink {
//                    PDFContentView()
//                } label: {
//                    LibraryButton(title: "PDF Section", icon: "doc.text ")
//                }
                
                
            }
            .padding()
        }
    }
}

struct LibraryButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(height: 140)
                .shadow(color: .blue.opacity(0.4), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
                Text(title)
                    .foregroundStyle(.white)
                    .font(.title2)
                    .bold()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle()) // Makes whole area tappable
    }
}

#Preview {
    MainLibraryView()
}
