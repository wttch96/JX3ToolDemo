//
//  NavIconView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct NavIconView: View {
    let nav: ToolNavItem
    
    var body: some View {
        VStack(spacing: 8) {
            Image(nav.iconImage)
                .resizable()
                .scaledToFit()
            Text(nav.title)
                .font(.subheadline)
        }
        .frame(width: 64, height: 64)
        .padding()
    }
}

extension View {

    func toolNav(_ nav: ToolNavItem) -> some View {
        NavigationLink(destination: {
            self
        }, label: {
            NavIconView(nav: nav)
        })
    }
}

struct NavIconView_Previews: PreviewProvider {
    static var previews: some View {
        NavIconView(nav: .equipEditor)
    }
}
