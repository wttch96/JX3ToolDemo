//
//  HomeView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            BoxNewsCarouselView()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), content: {
                TalentPicker()
                    .toolNav(.talnetEditor)
                EquipHomeView()
                    .toolNav(.equipEditor)
            })
            Spacer()
        }
        .padding(.top, 48 )
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
