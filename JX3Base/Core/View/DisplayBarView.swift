//
//  DisplayBarView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

struct DisplayBarView<Content>: View where Content: View {
    
    let iconName: String
    let title: String
    
    private let view: Content
    
    init(iconName: String, title: String, @ViewBuilder content: () -> Content) {
        self.iconName = iconName
        self.title = title
        self.view = content()
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: iconName)
                Text(title)
                Spacer()
            }
            .foregroundColor(Color.theme.title)
            .bold()
            view
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.bar)
                // .shadow(color: .pink.opacity(0.6), radius: 8)
        )
        .padding()
    }
}

struct DisplayBarView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayBarView(iconName: "star.fill", title: "标题") {
            VStack {
                ForEach(0..<10) { id in
                    Text("\(id)")
                }
            }
        }
    }
}
