//
//  File.swift
//  ThinkFlip
//
//  Created by Pranav on 25/01/25.
//

import Foundation

struct ScannedDoc : Identifiable {
    let id = UUID()
    let text:String
    let dateScanned:Date
}
