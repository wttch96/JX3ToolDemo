//
//  TalentPickerViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/31.
//

import Foundation
import Combine
import SwiftUI

class TalentPickerViewModel: ObservableObject {
    @Published var version: TalentVersion? = nil
    @Published var kungfu: Mount = .common
    @Published var talents: [TalentLevel] = []
    
    var cancellables = Set<AnyCancellable>()
    
    private var service: TalentService = TalentService()
    
    init() {
        addSubscriber()
    }
    
    private func addSubscriber() {
        $version.sink { [weak self] version in
            if let version = version, let self = self {
                service.loadTalents(version)
            }
        }
        .store(in: &cancellables)
        
        service.$talents
            .combineLatest($kungfu)
            .sink { [weak self] talentLevelMap, kungfu in
                if let talents = talentLevelMap[kungfu.name] {
                    self?.talents = talents.sorted()
                }
            }
            .store(in: &cancellables)
    }
    
}
