import SwiftUI

// MARK: - Reusable Components

// Custom Button Component
struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: 1.0)
    }
}

// Navigation Button Component
struct NavigationActionButton<Destination: View>: View {
    let title: String
    let icon: String
    let color: Color
    let destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Profile Avatar Component
struct ProfileAvatar: View {
    let profileImageBase64: String?
    let size: CGFloat = 36
    
    var body: some View {
        Group {
            if let base64 = profileImageBase64,
               let uiImage = UIImage.fromBase64(base64) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(radius: 10)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

// Document Card Component
struct DocumentCard: View {
    let document: ScannedDocModel
    let dateFormatter: DateFormatter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(document.text)
                .font(.system(size: 15, weight: .medium))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.blue.opacity(0.7))
                    .font(.system(size: 12))
                
                Text("Scanned on \(document.dateScanned, formatter: dateFormatter)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue.opacity(0.6))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
}

// Empty State Component
struct EmptyListStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.gray.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No Documents Yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Start by scanning your first document")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6).opacity(0.3))
    }
}

// Welcome Header Component
struct WelcomeHeader: View {
    let userName: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(userName.isEmpty ? "User" : userName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

// MARK: - Main View
struct ScanningView: View {
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("profilePhoto") private var profileImageBase64: String?
    @Environment(\.modelContext) private var context
    @StateObject private var svm = ScanViewModel()
    @State private var navigateToTextInputView = false
    @EnvironmentObject var cardVM: CardViewModel
    
    private let gridColumns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                GradientBackground()
                
                VStack(spacing: 0) {
                    // Welcome Header
                    WelcomeHeader(userName: userName)
                        .padding(.bottom, 20)
                    
                    // Document List ONLY
                    if svm.allScannedDocs.isEmpty {
                        EmptyListStateView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(svm.allScannedDocs) { document in
                                NavigationLink(destination: DetailTextView(myDetailedText: document.text)) {
                                    DocumentCard(document: document, dateFormatter: dateFormatter)
                                }
                            }
                            .onDelete(perform: svm.deleteDocument)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        
                    }
                    
                
                    // Action Buttons - OUTSIDE the list, fixed at bottom
                    VStack(spacing: 16) {
                        ActionButton(
                            title: "Scan Document",
                            icon: "doc.viewfinder",
                            color: .blue,
                            action: svm.startScanning
                        )
                        
                        LazyVGrid(columns: gridColumns, spacing: 16) {
                            Button(action: { navigateToTextInputView = true }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 24, weight: .medium))
                                    Text("Enter Text")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(
                                            colors: [Color.green, Color.green.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                )
                                .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            NavigationLink(
                                destination: PDFContentView()
                                    .environmentObject(svm)
                            ) {
                                VStack(spacing: 8) {
                                    Image(systemName: "doc.richtext")
                                        .font(.system(size: 24, weight: .medium))
                                    Text("Upload PDF")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(LinearGradient(
                                            colors: [Color.orange, Color.orange.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                )
                                .shadow(color: Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                    .background(
                        LinearGradient(
                            colors: [Color.clear, Color.black.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToTextInputView) {
                TextInputView()
            }
            .sheet(isPresented: $svm.isPresentingScanner) {
                DocumentScannerView(viewModel: svm)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: MainLibraryView()) {
                        Image(systemName: "books.vertical")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: ProfileEditView()) {
                        ProfileAvatar(profileImageBase64: profileImageBase64)
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
// MARK: - Preview
#Preview {
    ScanningView()
        .preferredColorScheme(.dark)
}

struct GradientBackground: View {
    var body: some View {
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
    }
}
