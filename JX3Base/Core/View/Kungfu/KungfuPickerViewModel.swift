//
//  KungfuLoaderViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation



/// 心法 ViewModel
class KungfuLoaderViewModel: ObservableObject {
    // 心法
    @Published var kungfus: [Kungfu] = []
    
    init() {
        loadKungfus()
    }
    
    /// 从文件中加载心法
    func loadKungfus() {
        if let kungfuMap = BundleUtil.loadJson("xf.json", type: [String: Kungfu].self) {
            // 过滤掉 山居剑意
            kungfus = kungfuMap.values.map { $0 }.filter { $0.name != "山居剑意" }.sorted()
        }
    }
}
