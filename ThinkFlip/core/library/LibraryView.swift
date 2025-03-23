import SwiftUI

struct LibraryView: View {
    @StateObject private var libVm = LibraryViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                if libVm.isLoading {
                    ProgressView("Loading history...")
                        .padding()
                } else if let errorMessage = libVm.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if libVm.history.isEmpty {
                    EmptyStateView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(libVm.history, id: \.id) { document in
                                NavigationLink(destination: DetailTextView(myDetailedText: document.content)) {
                                    HistoryCardView(document: document)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Scan History")
            .onAppear { libVm.fetchHistory() }
        }
    }
}

struct HistoryCardView: View {
    let document: ScannedDoc
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(document.content)
                .font(.body)
                .lineLimit(4)
                .foregroundColor(.primary)
            
            Text("Scanned on \(document.date)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 150)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        .shadow(radius: 2)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            Text("No history found.")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Start scanning to see your saved texts!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding()
    }
}

#Preview {
    LibraryView()
}
