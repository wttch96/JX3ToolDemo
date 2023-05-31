//
//  KungfuLoaderViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation

class KungfuLoaderViewModel: ObservableObject {
    @Published var kungfus: [Kungfu] = []
    
    init() {
        loadKungfus()
    }
    
    func loadKungfus() {
        if let kungfuMap = BundleUtil.loadJson("xf.json", type: [String: Kungfu].self) {
            kungfus = kungfuMap.values.map { $0 }.filter { $0.name != "山居剑意" }.sorted()
        }
    }
}
