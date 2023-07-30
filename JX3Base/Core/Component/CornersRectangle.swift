//
//  CornersRectangle.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct CornersRectangle: Shape {
    let topLeft: CGFloat
    let topRight: CGFloat
    let bottomLeft: CGFloat
    let bottomRight: CGFloat
    
    init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
    
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        
        let tr = min(topRight, h / 2, w / 2)
        let tl = min(topLeft, h / 2, w / 2)
        let bl = min(bottomLeft, h / 2, w / 2)
        let br = min(bottomRight, h / 2, w / 2)
        return Path { path in
            path.move(to: CGPoint(x: w / 2, y: 0))
            path.addLine(to: CGPoint(x: w - tr, y: 0))
            path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle.degrees(-90), endAngle: Angle.degrees(0), clockwise: false)
            path.addLine(to: CGPoint(x: w, y: h - br))
            path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
            path.addLine(to: CGPoint(x: bl, y: h))
            path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: tl))
            path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        
        }
    }
}

extension CornersRectangle {
    init(topLeftBottomRight: CGFloat, topRightBottomLeft: CGFloat) {
        self.init(topLeft: topLeftBottomRight, topRight: topRightBottomLeft, bottomLeft: topRightBottomLeft, bottomRight: topLeftBottomRight)
    }
}

struct CornersRectangle_Previews: PreviewProvider {
    static var previews: some View {
        CornersRectangle(topLeft: 40, topRight: 16, bottomLeft: 16, bottomRight: 40)
            .foregroundColor(.brown)
            .frame(height: 120)
    }
}
