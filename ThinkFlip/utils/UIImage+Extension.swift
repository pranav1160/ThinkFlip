//
//  UIImage+Extension.swift
//  ThinkFlip
//
//  Created by Pranav on 13/08/25.
//

import UIKit

extension UIImage {
    var jpegDataBase64: String? {
        jpegData(compressionQuality: 0.8)?.base64EncodedString()
    }
    
    static func fromBase64(_ base64: String) -> UIImage? {
        guard let data = Data(base64Encoded: base64) else { return nil }
        return UIImage(data: data)
    }
}
