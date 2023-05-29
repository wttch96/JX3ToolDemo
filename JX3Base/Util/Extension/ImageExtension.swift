//
//  ImageExtension.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import Foundation
import SwiftUI

#if os(OSX)
extension NSImage {
    func pngData() -> Data? {
        guard
            let imageData = image.tiffRepresentation,
            let imageResp = NSBitmapImageRep(data: imageData),
            let url = getURLForFile(imageName, folderName: folderName)
        else { return nil }
        
        return imageResp.representation(using: .png, properties: [:])
    }
    
    init(data: Data) {
        self.init(avatarData: NSData(data: data))
    }
}
#endif
