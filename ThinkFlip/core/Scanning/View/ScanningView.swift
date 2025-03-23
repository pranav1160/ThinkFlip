//
//  ScanningView.swift
//  ThinkFlip
//
//  Created by Pranav on 25/01/25.
//

import SwiftUI

struct ScanningView: View {
    
    @StateObject private var svm = ScanViewModel()
    @State private var navigateToCardView = false
    @State private var navigateToTextInputView = false
    @StateObject private var cardVM = CardViewModel() // ✅ Shared ViewModel
    @ObservedObject var authVm:AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if svm.allScannedDocs.isEmpty {
                    Text("No scanned documents yet")
                        .foregroundColor(.gray)
                } else {
                    List(svm.allScannedDocs) { document in
                        NavigationLink(destination: DetailTextView(myDetailedText:document.text)){
                            VStack(alignment: .leading) {
                                Text(document.text)
                                    .lineLimit(3)
                                Text("Scanned on \(document.dateScanned, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                      
                    }
                }
                
                Button(action: svm.startScanning) {
                    Text("Scan Document")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                
                NavigationStack {
                    VStack {
                        Button {
                            navigateToTextInputView = true
                        }label: {
                            Text("Enter Text 📝")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .navigationDestination(isPresented: $navigateToTextInputView) {
                        TextInputView(viewModel: cardVM)
                    }
                }
                .padding()
            }
            .navigationTitle("Welcom \(authVm.user?.name)")
            .sheet(isPresented: $svm.isPresentingScanner) {
                DocumentScannerView(viewModel: svm) // Use a proper scanner view.
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

#Preview {
    ScanningView(authVm:AuthViewModel())
}
