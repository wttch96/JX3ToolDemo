//
//  TalentPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct TalentPicker: View {
    
    @State private var version: TalentVersion? = nil
    @State private var kungfu: Kungfu = .common
    
    var body: some View {
        VStack {
            TalentVersionPicker(selectedVersion: $version)
            KungfuPicker(selectedKungfu: $kungfu)
        }
    }
}

struct TalentPicker_Previews: PreviewProvider {
    static var previews: some View {
        TalentPicker()
    }
}
