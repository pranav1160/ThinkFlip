//
//  File.swift
//  ThinkFlip
//
//  Created by Pranav on 25/01/25.
//

import Foundation

struct ScannedDocModel : Identifiable {
    let id = UUID()
    let text:String
    let dateScanned:Date
}
