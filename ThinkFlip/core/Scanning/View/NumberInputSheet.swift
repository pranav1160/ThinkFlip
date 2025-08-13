import SwiftUI

struct NumberInputSheet: View {
    var title: String
    @Binding var value: String
    var onDone: () -> Void
    
    @State private var selectedNumber: Int = 5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(title)
                    .font(.title2)
                    .padding(.top)
                
                // Wheel Picker
                Picker("Select Number", selection: $selectedNumber) {
                    ForEach(0...25, id: \.self) { num in
                        Text("\(num)")
                            .font(.system(size: 28, weight: .bold)) // Bigger text
                            .tag(num)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 250) // Taller picker
                .clipped() // Keeps it neat

                
                // Done button
                Button("Done") {
                    value = "\(selectedNumber)"
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
                selectedNumber = Int(value) ?? 5
            }
        }
    }
}
