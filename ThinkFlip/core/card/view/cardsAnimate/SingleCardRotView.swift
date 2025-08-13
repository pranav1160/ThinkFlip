import SwiftUI

struct SingleCardRotView: View {
    @State private var isFlipped = false
    
    let title: String
    let bodyText: String
    let frontColor: Color
    
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
            
        
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(frontColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    // **Front Side (Title + Body)**
    private var backSide: some View {
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
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(frontColor)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    
    }


#Preview {
    SingleCardRotView(
        title: "Explore the World",
        bodyText: "Discover new places, experiences, and cultures through our immersive platform.",
        frontColor: .blue
    )
}
