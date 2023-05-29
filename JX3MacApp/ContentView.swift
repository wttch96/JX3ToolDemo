//
//  ContentView.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            JX3BoxIcon(id: 1)
            JX3BoxIcon(id: 3)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
