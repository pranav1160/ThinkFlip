import SwiftUI
import SwiftData


struct CardLibraryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query private var savedDecks: [MessageResponse]
    @State private var selectedDeck: MessageResponse?
    
    var body: some View {
        NavigationStack {
            if savedDecks.isEmpty {
                EmptyStateView()
                
            } else {
                List {
                    ForEach(savedDecks) { deck in
                        NavigationLink {
                            LibraryStackView(
                                deck: deck, // pass actual object
                                colors: [.red, .blue, .green, .purple, .orange, .pink, .teal]
                            )
                        } label: {
                            DeckSectionView(deck: deck)
                        }
                    }
                }
            }
        }
        .navigationTitle("Saved Decks")
    }
}

struct DeckSectionView: View {
    let deck: MessageResponse
    
    var body: some View {
        HStack {
            Text(deckTitle)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .listRowSeparator(.hidden)
    }
    
    private var deckTitle: String {
        if let firstCard = deck.result.first {
            return firstCard.title.isEmpty ? "Untitled Deck" : firstCard.title
        }
        return "Untitled Deck"
    }
}

struct HistoryCardView: View {
    let deck: CardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(deck.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(deck.cardDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 150)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)))
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
    CardLibraryView()
}
