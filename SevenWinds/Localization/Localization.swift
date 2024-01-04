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
            String(localized: "auth.registerTitle")
        case .loginTitle:
            String(localized: "auth.loginTitle")
        case .registerButtonTitle:
            String(localized: "auth.registerButton")
        case .loginButtonTitle:
            String(localized: "auth.loginButton")
        case .password:
            String(localized: "auth.password")
        case .email:
            String(localized: "auth.email")
        case .confirmPassword:
            String(localized: "auth.confirmPassword")
        case .createAccount:
            String(localized: "auth.openRegister")
        }
    }
}

enum MainPageLocalization {
    case distance(meters: Int)
    case nearbyLocationsTitle
    case onMapButtonTitile
    case menuTitle
    case price(rub: Int)
    case waitTime(waitTime: Int)
    case buyButtonTitle
    case buyViewTitle
    case openPaymentButton
    
    var localized: String {
        switch self {
        case .distance(let meters):
            String(localized: "mainPage.coffeeshopDistance.\(meters)")
        case .nearbyLocationsTitle:
            String(localized: "mainPage.nearbyCoffeeTitle")
        case .onMapButtonTitile:
            String(localized: "mainPage.onMapButton")
        case .menuTitle:
            String(localized: "mainPage.menuTitle")
        case .price(let rub):
            String(localized: "mainPage.price.\(rub)")
        case .waitTime(let waitTime):
            String(localized: "mainPage.waitTime.\(waitTime)")
        case .buyButtonTitle:
            String(localized: "mainPage.buyButton")
        case .buyViewTitle:
            String(localized: "mainPage.buyViewTitle")
        case .openPaymentButton:
            String(localized: "mainPage.openBuyViewButton")
        }
    }
}
