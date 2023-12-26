//
//  AppState.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import Foundation

protocol AppStateService {
    var userCredentials: Credentials? { get }
    func setCredentials(_ credentials: Credentials)
}

class UserDefaultAppState: AppStateService {
    private (set) var userCredentials: Credentials?
    private let credentialsStorage: UserDefaults
    
    init(with credentialsStorage: UserDefaults) {
        self.credentialsStorage = credentialsStorage
        fetchCredentials()
    }
    
    private func fetchCredentials() {
        userCredentials = credentialsStorage.object(forKey: "user_credentials") as? Credentials
    }
    
    func setCredentials(_ credentials: Credentials) {
        credentialsStorage.setValue(credentials, forKey: "user_credentials")
        userCredentials = credentials
    }
}
