//
//  ScanningView.swift
//  ThinkFlip
//
//  Created by Pranav on 25/01/25.
//
import SwiftUI

struct ScanningView: View {
    
    @Environment(\.modelContext) private var context
    @StateObject private var svm = ScanViewModel()
    @State private var navigateToCardView = false
    @State private var navigateToTextInputView = false
    @State private var navigateToLibraryView = false
    @State private var navigateToRootView = false
    @EnvironmentObject var cardVM: CardViewModel
   
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
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
                            .onDelete(perform: svm.deleteDocument)
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
                            TextInputView()
                        }
                    }
                    .padding()
                }
                .navigationTitle("Welcome User")
                .sheet(isPresented: $svm.isPresentingScanner) {
                    DocumentScannerView(viewModel: svm)
                }
                
                .navigationDestination(isPresented: $navigateToLibraryView) {
                    LibraryView()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            LibraryView()
                        } label: {
                            Image(systemName: "book")
                        }

                    }
                }
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
    ScanningView()
}
