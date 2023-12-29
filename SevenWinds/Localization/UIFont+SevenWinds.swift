//
//  UIFont+SevenWinds.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import Foundation
import UIKit

enum SevenWindsFonts {
    case sfUiDisplay
    
    var font: UIFont? {
        switch self {
        case .sfUiDisplay:
            return UIFont(name: fontName + "-Semibold", size: 15)
        }
    }
    
    var bold: UIFont? {
        switch self {
        case .sfUiDisplay:
            return UIFont(name: fontName + "-Heavy", size: 15)
        }
    }
    
    private var fontName: String {
        switch self {
        case .sfUiDisplay:
            return "SFUIDisplay"
        }
    }
}
