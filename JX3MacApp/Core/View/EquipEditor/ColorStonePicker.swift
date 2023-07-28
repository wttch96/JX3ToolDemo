//
//  ColorStonePicker.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/27.
//

import SwiftUI

struct ColorStonePicker: View {
    let mount: Mount?
    @Binding var selection: ColorStone?
    
    @StateObject private var vm = ColorStonePickerViewModel()
    
    var body: some View {
        HStack {
            VStack {
                List {
                    if let _ = self.mount {
                        Toggle("匹配心法", isOn: $vm.matchMount)
                    }
                    pickerOptionView("第一属性", selection: $vm.option1, options: vm.options1)
                    pickerOptionView("第二属性", selection: $vm.option2, options: vm.options2)
                    pickerOptionView("第三属性", selection: $vm.option3, options: vm.options3)
                    Picker("五彩石等级", selection: $vm.level, content: {
                        ForEach(0..<6, content: { level in
                            Text("\((level + 1).traditionalChinese)级")
                                .tag(level + 1)
                        })
                    })
                    
                    detailView
                }
            }
            .frame(width: 360)
            ScrollView {
                VStack {
                    if vm.colorStones.isEmpty {
                        HStack {
                            Text("没有[\(vm.option1?.remark ?? "")]-[\(vm.option2?.remark ?? "")]-[\(vm.option3?.remark ?? "")]的五彩石")
                                .foregroundColor(.accentColor)
                            Spacer()
                        }
                    } else {
                        ForEach(vm.colorStones) { colorStone in
                            HStack {
                                JX3BoxIcon(id: Int(colorStone.icon) ?? 0)
                                    .frame(width: 36, height: 36)
                                
                                Text(colorStone.name)
                                    .foregroundColor(colorStone.color)
                                Spacer()
                                Text(colorStone.briefRemark)
                            }
                            .onHover(perform: { value in
                                if value {
                                    vm.focusColorStone = colorStone
                                }
                            })
                            .onTapGesture {
                                self.selection = colorStone
                            }
                            .padding(.horizontal)
                            .background(.background)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadOptions()
        }
        .onChange(of: mount) { newValue in
            loadOptions()
        }
        .onChange(of: vm.matchMount) { newValue in
            loadOptions()
        }
    }
    
    private var detailView: some View {
        ZStack {
            if let colorStone = vm.focusColorStone {
                VStack(alignment: .leading) {
                    Text(colorStone.name)
                        .bold()
                        .foregroundColor(colorStone.color)
                    Text("使用：熔嵌到武器上，可给武器带来强大的威力。")
                        .foregroundColor(.green)
                    
                    ForEach(colorStone.attributes) { attr in
                        Text("属性\(attr.index)：\(attr.remark)\(attr.value1)")
                            .foregroundColor(.yellow)
                        
                        HStack(alignment: .top, spacing: 0) {
                            Text("条件\(attr.index)：")
                            Text("全身的(五行石)大于等于 \(attr.diamondCount) 颗\n(五行石)等级和大于等于 \(attr.diamondIntensity) 级")
                        }
                        .foregroundColor(.brown)
                    }
                }
                .padding()
                .background(Color.theme.panel)
            } else {
                EmptyView()
            }
        }
    }
    
    private func pickerOptionView(_ title: String, selection: Binding<ColorStoneOption?>, options: [ColorStoneOption]) -> some View {
        
        return Picker(title, selection: selection, content: {
            ForEach(options) { item in
                Text("\(item.label)(\(item.remark))")
                    // ⚠️; 一定要这么设置，不然 bug 无法更新
                    .tag(item as ColorStoneOption?)
            }
            Text("无").tag(nil as ColorStoneOption?)
        })
    }
    
    private func loadOptions() {
        if let mount = self.mount, vm.matchMount {
            vm.options1 = AssetJsonDataManager.shared.colorStoneOptions.t1box.filter({ $0.mounts.contains(mount.id) })
            vm.options2 = AssetJsonDataManager.shared.colorStoneOptions.t2box.filter({ $0.mounts.contains(mount.id) })
            vm.options3 = AssetJsonDataManager.shared.colorStoneOptions.t3box.filter({ $0.mounts.contains(mount.id) })
        } else {
            vm.options1 = AssetJsonDataManager.shared.colorStoneOptions.t1box
            vm.options2 = AssetJsonDataManager.shared.colorStoneOptions.t2box
            vm.options3 = AssetJsonDataManager.shared.colorStoneOptions.t3box
        }
    }
}

struct ColorStonePicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorStonePicker(mount: dev.mount1, selection: .constant(nil))
    }
}
