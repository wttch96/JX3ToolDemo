//
//  CustomNavBarContainerView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct CustomNavBarContainerView<Content: View>: View {
    
    let content: Content
    
    @State private var showBackButton: Bool = true
    @State private var title: String = "Title"
    @State private var subtitle: String? = "Subtitle"
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavBarView(title: title, subtitle: subtitle, showBackButton: showBackButton)
        
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self, perform: { newValue in
            title = newValue
        })
        .onPreferenceChange(CustomNavBarSubTitlePreferenceKey.self, perform: { newValue in
            subtitle = newValue
        })
        .onPreferenceChange(CustomNavBarShowButtonPreferenceKey.self, perform: { newValue in
            showBackButton = newValue
        })
    }
}

struct CustomNavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarContainerView {
            ZStack {
                Color.green.ignoresSafeArea()
                
                Text("Test")
                    .foregroundColor(.white)
            }
        }
    }
}
