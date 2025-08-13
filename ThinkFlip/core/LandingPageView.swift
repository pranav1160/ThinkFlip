//
//  LandingPageView.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//

import SwiftUI

struct LandingPageView: View {
    var body: some View {
        ZStack {
            Color.theme.ligthPink
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(.dissapointedBear)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .shadow(radius: 10)
                    .padding(.bottom,30)
                    .scaleEffect(1.1)
                
                Spacer()
                
                HStack{
                    VStack(alignment:.leading){
                        
                        
                        Text("Tired Of")
                            .font(.system(size: 30,weight: .bold))
                            .foregroundStyle(.gray)
                        
                        Text("Boring Books")
                            .font(.system(size: 40,weight: .bold))
                            .foregroundStyle(.gray)
                        
                    }
                    .padding(.horizontal,35)
                    
                    
                    Spacer()
                }
                .padding(.vertical)
                
                
                NavigationLink {
                    LandingPageViewTwo()
                } label: {
                    Text("YES")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.pink)
                        )
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

//#Preview {
//    LandingPageView()
//}


struct LandingPageViewTwo: View {
    @State private var tempName = ""
    @AppStorage("userName") private var savedUserName = ""
    @Environment(\.dismiss) private var dismiss
   
    var body: some View {
        ZStack {
            Color.theme.ligthPink
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image(.phoneBear)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .shadow(radius: 10)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Enter your Name")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.gray)
                        
                        Text("To Get Started")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.gray)
                    }
                    .padding(.horizontal, 35)
                    
                    Spacer()
                }
                .padding(.vertical)
                
                HStack(spacing: 16) {
                   
                    TextField("Enter Name", text: $tempName)
                        .padding()
                        .font(.system(size: 24))        // big text
                        .background(Color(.systemGray6)) // light gray background
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    
                    Button {
                        let trimmed = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        
                        savedUserName = trimmed
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.pink)
                            )
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    LandingPageView()
}
