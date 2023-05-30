//
//  AutoResizeLazyVGrid.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import SwiftUI


/// 自动适配大小的 LazyVGrid
struct AutoResizeLazyVGrid<T, ContentView>: View where ContentView: View, T: Identifiable {
    // 列数量
    @State private var columnCount: Int = 1
    // 行数量
    @State private var rowCount: Int = 1
    
    // 数据
    private let data: [T]
    // 格子大小
    private let gridSize: CGSize
    private let childBuilder: (T) -> ContentView
    
    /// 构建自动适配的 LazyVGrid
    /// - Parameters:
    ///   - data: 所有的数据数组
    ///   - gridSize: 格子大小
    ///   - content: 数据的 ViewBuilder
    init(_ data: [T], gridSize: CGSize = CGSize(width: 36, height: 36), @ViewBuilder content: @escaping (T) -> ContentView) {
        self.data = data
        self.gridSize = gridSize
        self.childBuilder = content
    }
    
    var body: some View {
        GeometryReader { proxy in
            LazyVGrid(columns: columnItems(proxy), spacing: 0) {
                ForEach(data) { item in
                    ZStack {
                        childBuilder(item)
                    }
                    .frame(width: gridSize.width, height: gridSize.height)
                }
            }
        }
        .frame(height: CGFloat(rowCount) * gridSize.height)
    }
    
    
    private func columnItems(_ proxy: GeometryProxy) -> [GridItem] {
        let columnCount = Int(proxy.size.width) / Int(gridSize.width)
        DispatchQueue.main.async {
            self.columnCount = columnCount
            self.rowCount = (columnCount == 0) ? 1 : data.count / columnCount + 1
        }
        return Array(repeating: GridItem(.flexible()), count: columnCount)
    }
}

struct AutoResizeLazyVGrid_Previews: PreviewProvider {
    struct Item : Identifiable {
        var id: Int
    }
    static var data: [Item] {
        get {
            var ret: [Item] = []
            for i in 0..<100 {
                ret.append(Item(id: i))
            }
            return ret
        }
    }
    static var previews: some View {
        AutoResizeLazyVGrid(data, gridSize: CGSize(width: 36, height: 48)) { item in
            Text("\(item.id)")
                .foregroundColor(.white)
                .frame(width: 24, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                )
        }
    }
}
