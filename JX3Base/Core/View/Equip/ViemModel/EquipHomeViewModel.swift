//
//  EquipHomeViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/8.
//

import Foundation
import Combine


class EquipHomeViewModel: ObservableObject {
    @Published var schools: [School] = []
    
    private let service = AssetJsonDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        schools = service.schoolData
    }
}
