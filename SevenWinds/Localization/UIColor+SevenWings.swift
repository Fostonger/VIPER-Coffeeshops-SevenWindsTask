//
//  UIColor+SevenWings.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import UIKit

enum SevenWindsColors {
    case brown
    case lightBrown
    case darkBrown
    
    var uiColor: UIColor {
        UIColor(named: uiColorName) ?? .black
    }
    
    private var uiColorName: String {
        switch self {
        case .brown:
            "SevenWindsBrown"
        case .lightBrown:
            "SevenWindsLightBrown"
        case .darkBrown:
            "SevenWindsDarkBrown"
        }
    }
}
