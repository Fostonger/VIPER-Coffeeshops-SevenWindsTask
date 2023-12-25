//
//  APIEndpoint.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import Foundation

protocol Endpoint {
    func getEndpoint() -> String
    var method: String { get }
}

enum AuthEndpoint: Endpoint {
    case login
    case register
    
    func getEndpoint() -> String {
        switch self {
        case .login:
            return endpointBase + "login"
        case .register:
            return endpointBase + "register"
        }
    }
    
    var method: String {
        switch self {
        case .login, .register:
            return "POST"
        }
    }
    
    var endpointBase: String {
        "auth/"
    }
}

enum LocationEndpoint: Endpoint {
    case fetchLocations
    case getLocationById(id: Int)
    
    func getEndpoint() -> String {
        switch self {
        case .fetchLocations:
            return "locations"
        case .getLocationById(let id):
            return "location/\(id)/menu"
        }
    }
    
    var method: String {
        switch self {
        case .fetchLocations, .getLocationById(_):
            return "GET"
        }
    }
}
