//
//  RootView.swift
//  ThinkFlip
//
//  Created by Pranav on 23/03/25.
//
import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isAuthenticated {
            ScanningView(authVm: authViewModel)
        } else {
            LoginView(authVm: authViewModel)
        }
    }
}
