//
//  CheckBoxToggleStyle.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/20.
//

import Foundation
import SwiftUI


#if os(iOS)
struct CheckBoxToggleStyle: ToggleStyle {

    public func makeBody(configuration: Configuration) -> some View {
        if configuration.isOn {
            HStack {
                Image(systemName: "checkmark.square.fill")
                configuration.label
                    .fontWeight(.bold)
                    .onTapGesture {
                        configuration.$isOn.wrappedValue.toggle()
                    }
            }
            .foregroundStyle(.tint)
        } else {
            HStack {
                Image(systemName: "square")
                configuration.label
                    .onTapGesture {
                        configuration.$isOn.wrappedValue.toggle()
                    }
            }
        }
    }
}


extension ToggleStyle where Self == CheckBoxToggleStyle {
    static var checkBox: CheckBoxToggleStyle {
        get {
            return CheckBoxToggleStyle()
        }
    }
}


struct CheckBoxToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Toggle("测试", isOn: .constant(true))
            Toggle("测试2", isOn: .constant(false))
        }
        .toggleStyle(.checkBox)
    }
}
#endif
