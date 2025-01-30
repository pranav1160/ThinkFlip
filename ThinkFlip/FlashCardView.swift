//
//  FlashCardView.swift
//  ThinkFlip
//
//  Created by Pranav on 31/01/25.
//

import SwiftUI

struct FlashCardView: View {
    let myTitle:String
    let myDescription:String
    
    var body: some View {
       
            VStack {
                Text(myTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .shadow(radius: 5)
                
                Text(myDescription)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.pink, Color.blue  , Color.cyan]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding()
            .scaleEffect(1)
            .animation(.easeInOut(duration: 0.3))
        }
    }
    


//#Preview {
//    FlashCardView()
//}
