//
//  AppState.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import Foundation

protocol AppStateService {
    var userCredentials: Credentials? { get }
    var token: String? { get }
    func setCredentials(_ credentials: Credentials)
    func setToken(_ token: String, expirationDate: Int32?)
}

final class UserDefaultAppState: AppStateService {
    private (set) var userCredentials: Credentials?
    private (set) var token: String? {
        get {
            if expirationDate != nil && expirationDate! <= .now {
                _token = nil
            }
            return _token
        }
        set {
            _token = newValue
        }
    }
    private var _token: String?
    private var expirationDate: Date?
    private let credentialsStorage: UserDefaults
    
    init(with credentialsStorage: UserDefaults) {
        self.credentialsStorage = credentialsStorage
        fetchCredentials()
    }
    
    private func fetchCredentials() {
        if let data = UserDefaults.standard.object(forKey: UserDefaultKeys.tokenExpiration.rawValue) as? Data,
           let credentials = try? JSONDecoder().decode(Credentials.self, from: data) {
             userCredentials = credentials
        }
    }
    
    private func fetchToken() {
        token = credentialsStorage.object(forKey: UserDefaultKeys.token.rawValue) as? String
        expirationDate = credentialsStorage.object(forKey: UserDefaultKeys.tokenExpiration.rawValue) as? Date
    }
    
    func setCredentials(_ credentials: Credentials) {
        if let encoded = try? JSONEncoder().encode(credentials) {
            credentialsStorage.set(encoded, forKey: UserDefaultKeys.userCredentials.rawValue)
        }
        userCredentials = credentials
    }
    
    func setToken(_ token: String, expirationDate: Int32? = nil) {
        credentialsStorage.setValue(token, forKey: UserDefaultKeys.token.rawValue)
        if let expirationDate = expirationDate {
            credentialsStorage.setValue(Date.now + TimeInterval(expirationDate),
                                        forKey: UserDefaultKeys.tokenExpiration.rawValue)
            self.expirationDate = Date.now + TimeInterval(expirationDate)
        }
        self.token = token
    }
    
    enum UserDefaultKeys: String {
        case tokenExpiration = "token_expiration"
        case userCredentials = "user_credentials"
        case token = "token"
    }
}
