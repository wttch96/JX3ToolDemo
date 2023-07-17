//
//  CustomNavBarView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct CustomNavBarView: View {
    
    let title: String
    let subtitle: String?
    let showBackButton: Bool
    @Environment(\.presentationMode) var presentationMode
    
    init(title: String, subtitle: String?, showBackButton: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.showBackButton = showBackButton
    }
    

    var body: some View {
        ZStack {
            HStack {
                if showBackButton {
                    Image(systemName: "chevron.left")
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                Spacer()
                Image(systemName: "plus")
            }
            VStack {
                Text(title)
                    .bold()
                    .font(.largeTitle)
                if let subtitle = subtitle {
                    Text(subtitle)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .accentColor(.white)
        .foregroundColor(.white)
        .font(.headline)
        .background(
            Color.blue.ignoresSafeArea(edges: .top)
        )
    }
}

struct CustomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavBarView(title: "Title", subtitle: "Subtitle", showBackButton: true)
            Spacer()
        }
    }
}
