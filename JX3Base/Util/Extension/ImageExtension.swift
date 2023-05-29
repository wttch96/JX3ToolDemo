//
//  ImageExtension.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI

#if os(OSX)
import AppKit
extension NSImage {
    func pngData() -> Data? {
        guard
            let imageData = self.tiffRepresentation,
            let imageResp = NSBitmapImageRep(data: imageData)
        else { return nil }
        
        return imageResp.representation(using: .png, properties: [:])
    }
}
#endif
