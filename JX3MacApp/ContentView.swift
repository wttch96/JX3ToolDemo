//
//  ContentView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader { geo in
            NavigationSplitView(sidebar: {
                
            }, detail: {
           
                VStack {
                    BoxNewsCarouselView(type: .common)
                        .frame(height: 100)
                    Spacer()
                }
                .frame(maxWidth: 200)
            })
        }
        .toolbar(content: {
            Text("XXX")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
