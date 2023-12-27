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
        userCredentials = credentialsStorage.object(forKey: "user_credentials") as? Credentials
    }
    
    private func fetchToken() {
        token = credentialsStorage.object(forKey: "token") as? String
        expirationDate = credentialsStorage.object(forKey: "token_expiration") as? Date
    }
    
    func setCredentials(_ credentials: Credentials) {
        credentialsStorage.setValue(credentials, forKey: "user_credentials")
        userCredentials = credentials
    }
    
    func setToken(_ token: String, expirationDate: Int32? = nil) {
        credentialsStorage.setValue(token, forKey: "token")
        if let expirationDate = expirationDate {
            credentialsStorage.setValue(Date.now + TimeInterval(expirationDate), forKey: "token_expiration")
            self.expirationDate = Date.now + TimeInterval(expirationDate)
        }
        self.token = token
    }
}
