//
//  TalentPicker.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI

struct TalentPicker: View {
    
    @State private var version: TalentVersion? = nil
    
    var body: some View {
        TalentVersionPicker(selectedVersion: $version)
    }
}

struct TalentPicker_Previews: PreviewProvider {
    static var previews: some View {
        TalentPicker()
    }
}
