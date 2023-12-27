//
//  UIFont+SevenWinds.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import Foundation
import UIKit

enum SevenWindsFonts {
    case sfUiDisplay(weight: Int)
    
    var font: UIFont? {
        switch self {
        case .sfUiDisplay:
            return UIFont(name: fontName, size: UIFont.labelFontSize)
        }
    }
    
    private var fontName: String {
        switch self {
        case .sfUiDisplay(let weight):
            return "sf-ui-display-\(weight).otf"
        }
    }
}
