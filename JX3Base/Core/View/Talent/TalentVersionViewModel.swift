//
//  ExtraPointVersionViewModel.swift
//  JX3Demo
//
//  Created by Wttch on 2023/5/30.
//

import Foundation
import Combine

class TalentVersionViewModel: ObservableObject {
    @Published var versions: [TalentVersion] = []
    @Published var isLoadidng: Bool = false
    
    private let service = TalentService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubcriber()
        isLoadidng = true
    }
    
    func loadVersion() {
        isLoadidng = true
        service.loadVersions()
    }
    
    private func addSubcriber() {
        service.$versions
            .sink { [weak self] versions in
                self?.isLoadidng = false
                self?.versions = versions
            }
            .store(in: &cancellables)
    }
    
}
