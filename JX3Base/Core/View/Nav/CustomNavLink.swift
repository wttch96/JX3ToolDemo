//
//  CustomNavLink.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct CustomNavLink<Label: View, Destination: View>: View {
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label:() -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label:() -> Label) {
        self.destination = destination()
        self.label = label()
    }
    
    var body: some View {
        NavigationLink(destination: {
            CustomNavBarContainerView(content: {
                destination
            })
            .navigationBarHidden(true)
        }, label: {
            label
        })
    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CustomNavLink(destination: { Text("Desination") }, label: {
                Text("Link")
            })
        }
    }
}
