import SwiftUI

struct NumberInputSheet: View {
    var title: String
    @Binding var value: String
    var onDone: () -> Void
    
    @State private var sliderValue: Double = 5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2)
                    .padding(.top)
                
                // Slider display
                Text("Selected: \(Int(sliderValue))")
                    .font(.headline)
                
                // Slider itself
                Slider(value: $sliderValue, in: 0...15, step: 1)
                    .padding(.horizontal)
                
                // Done button
                Button("Done") {
                    value = "\(Int(sliderValue))"
                    onDone()
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Set initial value from binding, fallback to 5
                sliderValue = Double(Int(value) ?? 5)
            }
        }
    }
}
