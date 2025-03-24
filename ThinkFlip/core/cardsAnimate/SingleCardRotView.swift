import SwiftUI

struct SingleCardRotView: View {
    @State private var isFlipped = false
    
    let title: String
    let bodyText: String
    let frontColor: Color
    let imageUrl: String
    let accuracy:Float
    
    var body: some View {
        
        ZStack {
            // **Front Side - Title & Body**
            frontSide
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? -180 : 0), axis: (x: 0, y: 1, z: 0))
            
            // **Back Side - Image**
            backSide
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 350, height: 460)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 8)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.8)) {
                isFlipped.toggle()
            }
        }
        
    }
    
    // **Front Side (Title + Body)**
    private var frontSide: some View {
        VStack(spacing: 15) {
            Spacer()
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            
            Text(bodyText)
                .font(.body)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            Spacer()
            
            HStack{
                Spacer()
                Text(
                    String(
                        format: "%.2f%%",
                        accuracy+Float.random(in: 0.01...0.99)
                    )
                )
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(frontColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    // **Back Side (Image)**
    private var backSide: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.3))
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 450)
                    .clipped()
            case .failure:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5) // Make it larger
                    .padding()
                   
                
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    SingleCardRotView(
        title: "Explore the World",
        bodyText: "Discover new places, experiences, and cultures through our immersive platform.",
        frontColor: .blue,
        imageUrl: "https://source.unsplash.com/random/400x500", accuracy: 0.987
    )
}
