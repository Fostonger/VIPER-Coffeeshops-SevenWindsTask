//
//  APIStructs.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import Foundation

struct Credentials: Encodable {
    let password: String
    let login: String
}

struct AuthResponse: Decodable {
    let token: String
    let tokenLifetime: Int32?
}

struct BigDecimal: Decodable {
    
}

struct LocationPoint: Decodable {
    let latitude: BigDecimal
    let longitude: BigDecimal
}

struct Location: Decodable {
    let id: Int32?
    let name: String
    let point: LocationPoint
}

struct LocationMenuItem: Decodable {
    let id: Int32?
    let name: String
    let imageURL: URL?
    let price: Int32?
}
