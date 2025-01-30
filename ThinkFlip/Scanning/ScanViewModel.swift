
import Foundation
import Vision
import VisionKit

class ScanViewModel: NSObject, ObservableObject, VNDocumentCameraViewControllerDelegate {
    @Published var allScannedDocs: [ScannedDoc] = []
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
                print("Error recognizing text: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let recognizedText = results.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            DispatchQueue.main.async {
                let document = ScannedDoc(text: recognizedText, dateScanned: Date())
                self?.allScannedDocs.append(document)
            }
        }
        request.recognitionLevel = .accurate
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform text recognition: \(error.localizedDescription)")
            }
        }
    }
}
