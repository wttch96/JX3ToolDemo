//
//  IconLibraryView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/29.
//

import SwiftUI

struct IconLibraryView: View {
    @StateObject private var vm: IconLibraryViewModel = IconLibraryViewModel()
    @State private var showLikedIcon: Bool = false
    
    var body: some View {
        VStack {
            header
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("请输入要查询的图标id", text: $vm.searchText)
                }
            }
            Spacer()
        }
    }
    
    private var header: some View {
        HStack {
            Spacer()
            Text("图标库")
            Spacer()
            CircleButton(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showLikedIcon ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showLikedIcon.toggle()
                    }
                }
        }
    }
}

struct IconLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        IconLibraryView()
    }
}
