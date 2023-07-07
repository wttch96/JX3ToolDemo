//
//  NavBarView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/7/7.
//

import SwiftUI

struct NavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                
                CustomNavLink(destination: {
                    VStack {
                        Text("Destination")
                            .navTitle("New Title")
                            .navSubtitle("None")
                            .showBackButton(true)
                        
                        CustomNavLink(destination: {
                            Text("Destination1")
                                .navTitle("New Title1")
                                .navSubtitle("None1")
                                .showBackButton(true)
                        }, label: {
                            Text("Navigate")
                                    .foregroundColor(.white)
                        })
                    }
                }, label: {
                    Text("Navigate")
                            .foregroundColor(.white)
                })
            }
        }
    }
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarView()
    }
}

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
