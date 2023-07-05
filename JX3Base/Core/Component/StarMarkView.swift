//
//  StarMarkView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/4.
//

import SwiftUI

struct StarMarkView: View {
    let maxCount: Int
    @Binding var selectedCount: Int
    
    var body: some View {
        HStack(spacing: 3) {
            if selectedCount > 0 {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
                    .onTapGesture {
                        selectedCount = 0
                    }
            }
            ForEach(1..<maxCount + 1, id: \.self) { index in
                Image(systemName: index <= selectedCount ? "star.fill" : "star")
                    .foregroundColor(.accentColor)
                    .onTapGesture {
                        selectedCount = index
                    }
            }
        }
    }
}

struct StarMarkView_Previews: PreviewProvider {
    static var previews: some View {
        StarMarkView(maxCount: 8, selectedCount: .constant(5))
    }
}
