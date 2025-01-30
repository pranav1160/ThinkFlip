import SwiftUI

struct DetailTextView: View {
    @StateObject private var cardVM = CardViewModel() // ✅ Shared ViewModel
    @State private var navigateToCardView = false
    
    let myDetailedText: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text(myDetailedText)
                    .padding()
                
                Button {
                    cardVM.sendMessage(text: myDetailedText) // ✅ Wait for API response
                        navigateToCardView = true  // ✅ Navigate only after response
                    
                } label: {
                    Text("Create Card")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(.rect(cornerRadius: 15))
                }
                .padding()
                
                NavigationLink("", destination: CardView(viewModel: cardVM), isActive: $navigateToCardView)
            }
        }
    }
}

#Preview {
    DetailTextView(myDetailedText: "hello")
}
