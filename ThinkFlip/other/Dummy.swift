import SwiftUI

struct DummyCardView: View {
    @State private var rotationAngle: Double = 0
    let myFront:String
    let myBack:String
    
    var body: some View {
        ZStack {
            
            Text(myBack)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
                .opacity((rotationAngle.truncatingRemainder(dividingBy: 360) >= 90 && rotationAngle.truncatingRemainder(dividingBy: 360) < 270) ? 1 : 0)
                .rotation3DEffect(
                    .degrees(rotationAngle - 180),
                    axis: (x: 0, y: 1, z: 0)
                )
            
            // Front Side
            Text(myFront)
                .font(.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(10)
                .foregroundColor(.white)
                .opacity((rotationAngle.truncatingRemainder(dividingBy: 360) < 90 || rotationAngle.truncatingRemainder(dividingBy: 360) >= 270) ? 1 : 0)
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
       
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.5)) {
                rotationAngle += 180  // Or any increment you want
            }
        }
    }
}

#Preview {
    DummyCardView(myFront: "front", myBack: "back")
}
