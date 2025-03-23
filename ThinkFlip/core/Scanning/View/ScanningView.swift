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
    @State private var navigateToLibraryView = false
    @StateObject private var cardVM = CardViewModel()
    @ObservedObject var authVm: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if svm.allScannedDocs.isEmpty {
                    Text("No scanned documents yet")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(svm.allScannedDocs) { document in
                            NavigationLink(destination: DetailTextView(myDetailedText: document.text)) {
                                VStack(alignment: .leading) {
                                    Text(document.text)
                                        .lineLimit(3)
                                    Text("Scanned on \(document.dateScanned, formatter: dateFormatter)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .onDelete(perform: cardVM.deleteDocument)
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
                        } label: {
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
            .navigationTitle("Welcome \(authVm.user!.name)")
            .sheet(isPresented: $svm.isPresentingScanner) {
                DocumentScannerView(viewModel: svm)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        navigateToLibraryView = true
                    } label: {
                        Image(systemName: "books.vertical") // Library icon
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLibraryView) {
                LibraryView()
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
    ScanningView(authVm: AuthViewModel())
}
