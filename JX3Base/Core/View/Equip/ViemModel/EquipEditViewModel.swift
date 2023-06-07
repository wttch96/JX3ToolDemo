//
//  EquipEditViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/6/7.
//

import Foundation


class EquipEditViewModel: ObservableObject {
    @Published var seletedEquip: [EquipPosition: Int?] = [:]
}
