//
//  PanelAttributeRowView.swift
//  JX3Demo
//
//  Created by Wttch on 2023/8/10.
//

import SwiftUI

struct PanelAttributeView: View {
    let attributes: EquipProgrammeAttributeSet
    let attr: PanelAttribute
    let isHeader: Bool
    let onlyText: Bool
    
    init(_ attr: PanelAttribute, attributes: EquipProgrammeAttributeSet, isHeader: Bool = false, onlyText: Bool = true) {
        self.attr = attr
        self.attributes = attributes
        self.isHeader = isHeader
        self.onlyText = onlyText
    }
    
    var body: some View {
        ZStack {
            if onlyText {
                Text("\(attr.desc)\(attributes.panelAttributes[attr.type]?.tryIntFormat ?? "")")
            } else {
                HStack {
                    Text(attr.desc)
                    Spacer()
                    if let value = attributes.panelAttributes[attr.type] {
                        Text("\(value.tryIntFormat)")
                    }
                }
            }
        }
        .padding(.horizontal)
        .foregroundColor(isHeader ? Color.theme.gold : .white)
    }
}

struct PanelAttributeRowView: View {
    let row: PanelAttributeRow
    let attributes: EquipProgrammeAttributeSet
    
    @State private var showPanelRows: Bool = false
    
    init(_ row: PanelAttributeRow, attributes: EquipProgrammeAttributeSet) {
        self.row = row
        self.attributes = attributes
    }
    
    var body: some View {
        PanelAttributeView(row.header, attributes: attributes, isHeader: true, onlyText: false)
        .onHover(perform: { hover in
            showPanelRows = hover
        })
        .popover(isPresented: $showPanelRows, attachmentAnchor: .point(.trailing), arrowEdge: .trailing, content: {
            VStack(alignment: .leading, spacing: 4) {
                PanelAttributeView(row.header, attributes: attributes, isHeader: true)
                ForEach(row.child) { attr in
                    PanelAttributeView(attr, attributes: attributes)
                }
            }
            .padding(.vertical)
        })
    }
}
