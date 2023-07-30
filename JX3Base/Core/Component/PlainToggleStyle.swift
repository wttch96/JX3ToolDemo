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
        configuration.label
            .foregroundColor(configuration.isOn ? .accentColor : .gray)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(
                        configuration.isOn ? Color.cyan.opacity(0.2) : Color.primary.opacity(0.1)
                    )
            }
            .onTapGesture {
                configuration.$isOn.wrappedValue.toggle()
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
