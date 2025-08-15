//
//  ContentView.swift
//  ThinkFlip
//
//  Created by Pranav on 15/08/25.
//

import SwiftUI

// MARK: - Views
struct PDFContentView: View {
    @StateObject private var viewModel = PDFTextExtractorViewModel()
    @EnvironmentObject var cardVM: CardViewModel
    @EnvironmentObject var scanVM:ScanViewModel
    @State private var navigateToDetailView = false
    
    var body: some View {
        ZStack {
            // Background Gradient to match your app theme
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.6),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                    
                    Text("PDF Text Extractor")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Select a PDF to create cards & quiz")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top)
                
                // File Selection Section
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.showingDocumentPicker = true
                    }) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Select PDF File")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    if !viewModel.selectedFileName.isEmpty && viewModel.selectedFileName != "No file selected" {
                        Text(viewModel.selectedFileName)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                }
                
                // Content Section
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text("Processing PDF...")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                        Text("Preparing for card creation")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !viewModel.errorMessage.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        
                        Text(viewModel.errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Try Again") {
                            viewModel.clearText()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if !viewModel.extractedText.isEmpty {
                    // Success state - show checkmark and auto-navigate
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)
                        
                        Text("PDF Processed Successfully!")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Redirecting to card creation...")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("No PDF selected")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Tap 'Select PDF File' to get started")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToDetailView) {
            DetailTextView(myDetailedText: viewModel.extractedText)
        }
        .sheet(isPresented: $viewModel.showingDocumentPicker) {
            DocumentPicker(showingPicker: $viewModel.showingDocumentPicker) { url in
                viewModel.extractTextFromPDF(url: url)
            }
        }
        .onChange(of: viewModel.extractedText) { oldValue, newValue in
            // Auto-navigate when text is extracted
            if !newValue.isEmpty && oldValue != newValue {
                
                scanVM.savePDFText(newValue, fileName: viewModel.selectedFileName)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    navigateToDetailView = true
                }
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PDFContentView()
        }
        .preferredColorScheme(.dark)
    }
}
