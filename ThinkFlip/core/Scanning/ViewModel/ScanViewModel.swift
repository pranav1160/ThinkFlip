
import Foundation
import Vision
import VisionKit

class ScanViewModel: NSObject, ObservableObject, VNDocumentCameraViewControllerDelegate {
    @Published var allScannedDocs: [ScannedDocModel] = [] {
        didSet {
            saveDocuments()
        }
    }
    @Published var isPresentingScanner = false
    
    private let storageKey = "scannedDocuments"
    
    override init() {
        super.init()
        loadDocuments()
    }
    
    func startScanning() {
        isPresentingScanner = true
    }
    
    func processScannedImages(_ images: [UIImage]) {
        var combinedText = ""
        
        let group = DispatchGroup()
        
        for image in images {
            group.enter()
            recognizeText(from: image) { recognizedText in
                combinedText += recognizedText + "\n\n"
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let document = ScannedDocModel(
                text: combinedText.trimmingCharacters(in: .whitespacesAndNewlines),
                dateScanned: Date()
            )
            // Insert at the beginning for newest-first order
            self.allScannedDocs.insert(document, at: 0)
        }
    }
    
    func deleteDocument(at offsets: IndexSet) {
        allScannedDocs.remove(atOffsets: offsets)
    }
    
    // MARK: - Persistence
    private func saveDocuments() {
        if let encoded = try? JSONEncoder().encode(allScannedDocs) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadDocuments() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([ScannedDocModel].self, from: savedData) {
            allScannedDocs = decoded
        }
    }
    
    // MARK: - Vision Scanner Delegates
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        var scannedImages: [UIImage] = []
        for pageIndex in 0..<scan.pageCount {
            scannedImages.append(scan.imageOfPage(at: pageIndex))
        }
        processScannedImages(scannedImages)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Scanning failed: \(error.localizedDescription)")
        controller.dismiss(animated: true)
    }
    
    private func recognizeText(from image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            completion("")
            return
        }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation], error == nil else {
                completion("")
                return
            }
            let recognizedText = results
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            completion(recognizedText)
        }
        
        request.recognitionLevel = .accurate
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}
