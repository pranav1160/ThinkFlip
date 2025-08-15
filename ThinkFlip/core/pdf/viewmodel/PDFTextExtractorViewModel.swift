//
//  PDFTextExtractorViewModel.swift
//  ThinkFlip
//
//  Created by Pranav on 15/08/25.
//

import Combine
import Foundation
import SwiftUI
import PDFKit
import UniformTypeIdentifiers

// MARK: - ViewModel
class PDFTextExtractorViewModel: ObservableObject {
    @Published var extractedText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedFileName: String = "No file selected"
    @Published var showingDocumentPicker = false
    
    func extractTextFromPDF(url: URL) {
        isLoading = true
        errorMessage = ""
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Start accessing the security-scoped resource
            let accessing = url.startAccessingSecurityScopedResource()
            
            defer {
                // Always stop accessing the resource when done
                if accessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            // Try to read the PDF document
            guard let pdfDocument = PDFKit.PDFDocument(url: url) else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to load PDF document. Please make sure it's a valid PDF file."
                    self?.isLoading = false
                }
                return
            }
            
            var fullText = ""
            let pageCount = pdfDocument.pageCount
            
            // Check if PDF has any pages
            guard pageCount > 0 else {
                DispatchQueue.main.async {
                    self?.errorMessage = "PDF document appears to be empty or corrupted."
                    self?.isLoading = false
                }
                return
            }
            
            for pageIndex in 0..<pageCount {
                if let page = pdfDocument.page(at: pageIndex) {
                    if let pageText = page.string {
                        fullText += pageText + "\n\n"
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.extractedText = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
                self?.selectedFileName = url.lastPathComponent
                self?.isLoading = false
                
                if fullText.isEmpty {
                    self?.errorMessage = "No text found in the PDF. It might be a scanned document or image-based PDF."
                }
            }
        }
    }
    
    func clearText() {
        extractedText = ""
        selectedFileName = "No file selected"
        errorMessage = ""
    }
}
