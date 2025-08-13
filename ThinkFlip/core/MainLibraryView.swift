//
//  MainLibraryView.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//

import SwiftUI

struct MainLibraryView: View {
    
    @State private var navigateToSavedQuizes = false
    @State private var navigateToSavedCards = false
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            HStack(spacing:20){
                
                NavigationLink{
                    CardLibraryView()
                }label: {
                    Text("Saved Cards")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.theme.blue1)
                                .frame(width: 160,height: 160)
                                
                        )
                        
                }
                .padding()
                
                
                
                NavigationLink{
                    QuizLibraryView()
                }label: {
                    Text("Saved Quizes")
                        .foregroundStyle(.white)
                        .font(.title2)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.theme.blue1)
                                .frame(width: 160,height: 160)
                        )
                }
                .padding()
                
            }
        }
    }
}

#Preview {
    MainLibraryView()
}
