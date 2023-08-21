//
//  ColorStonePickerViewModel.swift
//  JX3MacApp
//
//  Created by Wttch on 2023/7/28.
//

import Foundation
import Combine

class ColorStonePickerViewModel: ObservableObject {
    @Published var matchMount = true
    @Published var option1: ColorStoneOption? = nil
    @Published var option2: ColorStoneOption? = nil
    @Published var option3: ColorStoneOption? = nil
    
    @Published var options1: [ColorStoneOption] = []
    @Published var options2: [ColorStoneOption] = []
    @Published var options3: [ColorStoneOption] = []
    
    @Published var level: Int = 6
    
    @Published var colorStones: [ColorStone] = []
    
    @Published var focusColorStone: ColorStone? = nil
    
    private var service = ColorStoneService()
    private var anyCancelles: [AnyCancellable] = []
    
    init() {
        service.$resp.sink { newValue in
            self.colorStones = newValue?.list.map({ $0.toEntity() }) ?? []
        }
        .store(in: &anyCancelles)
        
        $matchMount.combineLatest($option1).combineLatest($option2).combineLatest($option3)
            .combineLatest($level)
            .sink(receiveValue: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    
                    self.load()
                })
            })
            .store(in: &anyCancelles)
    }
    
    func load() {
        logger("开始下载五彩石...")
        service.loadColorStone(option1, option2, option3, level: level)
    }
}
