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
                Text("\(attr.desc)\(valueText)")
            } else {
                HStack {
                    Text(attr.desc)
                    Spacer()
                    Text(valueText)
                }
            }
        }
    }
    
    private var valueText: String {
        if attr.isPercent {
            return String(format: "%.2f%%", attributes.panelAttributes[attr.type, default: 0] * 100)
        } else {
            return attributes.panelAttributes[attr.type]?.tryIntFormat ?? ""
        }
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
                    .foregroundColor(.theme.gold)
                ForEach(row.child, id: \.first?.id) { attrRow in
                    HStack(spacing: 4, content: {
                        ForEach(attrRow) { attr in
                            PanelAttributeView(attr, attributes: attributes)
                        }
                    })
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
        })
    }
}

struct PanelAttributeGroupView: View {
    let group: PanelAttributeGroup
    let attributes: EquipProgrammeAttributeSet
    
    init(group: PanelAttributeGroup, attributes: EquipProgrammeAttributeSet) {
        self.group = group
        self.attributes = attributes
    }
    
    var body: some View {
        Section(content: {
            ForEach(group.child, content: { row in
                PanelAttributeRowView(row, attributes: attributes)
            })
        }, header: {
            Text(group.title)
                .foregroundColor(.theme.gold)
        })
    }
}
