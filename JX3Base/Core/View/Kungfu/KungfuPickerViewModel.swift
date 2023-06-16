//
//  KungfuLoaderViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation
import Combine

/// 心法 ViewModel
class KungfuLoaderViewModel: ObservableObject {
    // 心法
    @Published var kungfus: [Kungfu] = []
    
    private let dataService = AssetJsonDataService.shared
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.kungfus = dataService.kungfuData
    }
}
