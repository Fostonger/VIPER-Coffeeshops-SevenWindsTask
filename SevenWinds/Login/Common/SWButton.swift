//
//  SWButton.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import UIKit

class SWButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                setupUIEnabled()
            } else {
                setupUIDisabled()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUIEnabled() {
        backgroundColor = SevenWindsColors.darkBrown.uiColor
        tintColor = SevenWindsColors.lightBrown.uiColor
        setupUI()
    }
    
    private func setupUIDisabled() {
        backgroundColor = .sevenWindsDisabledBrown
        tintColor = SevenWindsColors.lightBrown.uiColor
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 24
        titleLabel?.font = SevenWindsFonts.sfUiDisplay.bold
    }
}
