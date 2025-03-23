
import Foundation
import Vision
import VisionKit

class ScanViewModel: NSObject, ObservableObject, VNDocumentCameraViewControllerDelegate {
    @Published var allScannedDocs: [ScannedDocModel] = []
    @Published var isPresentingScanner = false
    
    func startScanning() {
        isPresentingScanner = true
    }
    
    // Method to process multiple scanned images
    func processScannedImages(_ images: [UIImage]) {
        for image in images {
            recognizeText(from: image) // Process each image
        }
    }
    
    // Delegate methods
    
    // Called when scanning is complete.
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var scannedImages: [UIImage] = []
        for pageIndex in 0..<scan.pageCount {
            scannedImages.append(scan.imageOfPage(at: pageIndex))
        }
        
        // Pass the images to the new method to process them
        processScannedImages(scannedImages)
        
        controller.dismiss(animated: true)
    }
    
    // Dismisses the scanner if the user cancels.
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    // Logs an error message and dismisses the scanner if scanning fails.
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Scanning failed with error: \(error.localizedDescription)")
        controller.dismiss(animated: true)
    }
    
    // Existing method to recognize text from a single image
    private func recognizeText(from image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedTextObservation], error == nil else {
                print("❌ Error recognizing text: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            DispatchQueue.main.async {
                let document = ScannedDocModel(text: recognizedText, dateScanned: Date())
                self?.allScannedDocs.append(document)
                
                // 🔥 Save text to backend API
                self?.saveScannedText(recognizedText)
            }
        }
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("❌ Failed to perform text recognition: \(error.localizedDescription)")
            }
        }
    }

}


extension ScanViewModel {
    func saveScannedText(_ text: String) {
        let apiURL = "https://thinkflip-backend.onrender.com/history/save-document"
        guard let url = URL(string: apiURL) else {
            print("❌ Invalid URL")
            return
        }
        
        // ✅ Fetch token from UserDefaults (since you stored it after login)
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("❌ No auth token found, user might not be logged in")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "authorization") // 🔥 Correct token format
        
        let body: [String: String] = ["content": text]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data received from API")
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("✅ Successfully saved document: \(responseString)")
            }
        }.resume()
    }
}


