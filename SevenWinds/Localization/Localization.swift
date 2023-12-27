//
//  Localization.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import Foundation

enum LoginLocalization {
    case registerTitle
    case loginTitle
    case registerButtonTitle
    case loginButtonTitle
    case password
    case email
    case confirmPassword
    case createAccount
    
    var localized: String {
        switch self {
        case .registerTitle:
            String(localized: "Register title")
        case .loginTitle:
            String(localized: "Login title")
        case .registerButtonTitle:
            String(localized: "Register button")
        case .loginButtonTitle:
            String(localized: "Login button")
        case .password:
            String(localized: "Password")
        case .email:
            String(localized: "Email")
        case .confirmPassword:
            String(localized: "Confirm password")
        case .createAccount:
            String(localized: "Open registration")
        }
    }
}
