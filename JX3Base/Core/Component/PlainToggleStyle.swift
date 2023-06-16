//
//  PlainToggleStyle.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/12.
//

import Foundation
import SwiftUI


struct PlainToggleStyle: ToggleStyle {

    public func makeBody(configuration: Configuration) -> some View {
        if configuration.isOn {
            configuration.label
                .foregroundColor(.accentColor)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor, lineWidth: 2)
                }
                .onTapGesture {
                    configuration.$isOn.wrappedValue.toggle()
                }
        } else {
            configuration.label
                .foregroundColor(.white)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color.gray)
                }
                .onTapGesture {
                    configuration.$isOn.wrappedValue.toggle()
                }
        }
    }
}

extension ToggleStyle where Self == PlainToggleStyle {
    static var plain: PlainToggleStyle {
        get {
            return PlainToggleStyle()
        }
    }
}



struct PlainToggleStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Toggle("测试", isOn: .constant(true))
            Toggle("按钮", isOn: .constant(false))
        }
        .toggleStyle(.plain)
    }
}
