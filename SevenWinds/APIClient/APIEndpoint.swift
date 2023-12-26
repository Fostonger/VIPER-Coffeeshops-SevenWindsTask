//
//  APIEndpoint.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import Foundation
import Alamofire

protocol Endpoint {
    func getEndpoint() -> String
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var authRequired: Bool { get }
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
    
    var method: HTTPMethod {
        switch self {
        case .login, .register:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .login, .register:
            return [.accept("application/json")]
        }
    }
    
    var authRequired: Bool { false }
    
    private var endpointBase: String {
        "auth/"
    }
}

enum LocationEndpoint: Endpoint {
    case fetchLocations
    case getLocationById(id: Int32)
    
    func getEndpoint() -> String {
        switch self {
        case .fetchLocations:
            return "locations"
        case .getLocationById(let id):
            return "location/\(id)/menu"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchLocations, .getLocationById:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getLocationById, .fetchLocations:
            return [.accept("application/json")]
        }
    }
    
    var authRequired: Bool { true }
}
