//
//  ContentView.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("userName") var userName: String = ""
    
    var body: some View {
        NavigationStack{
            if userName.isEmpty {
                LandingPageView()
            } else {
                ScanningView()
            }
        }
       
    }
}

#Preview {
    ContentView()
}
