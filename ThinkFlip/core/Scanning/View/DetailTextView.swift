import SwiftUI

struct DetailTextView: View {
    @StateObject private var cardVM = CardViewModel() // ✅ Shared ViewModel
    @State private var navigateToCardView = false
    
    let myDetailedText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // **Scrollable Fixed Frame Text View**
                ScrollView {
                    Text(myDetailedText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .frame(height: 550) // ✅ Fixed height for scrollable text
                Spacer()
                // **Send Button**
                Button {
                    cardVM.sendMessage(text: myDetailedText)
                    navigateToCardView = true  // ✅ Navigate after response
                } label: {
                    Text("Create Card")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(radius: 3)
                }
                .padding(.horizontal)
                
            }
            .navigationDestination(
                isPresented: $navigateToCardView,
                destination: {
                    CardView(viewModel: cardVM)
                }
            )
            .padding()
        }
    }
}

#Preview {
    DetailTextView(myDetailedText: "This is a scanned text example. You can review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here beforesending.review it here before sending.review it here beforesending.review it here before sending.review it here beforesending.review it here before sending.review it here beforesending.review it here before sending.review it here beforesending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending.review it here before sending")
}
