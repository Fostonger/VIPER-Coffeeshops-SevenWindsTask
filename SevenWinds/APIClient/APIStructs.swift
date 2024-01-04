//
//  APIStructs.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import Foundation

struct Credentials: Codable {
    let password: String
    let login: String
}

struct AuthResponse: Decodable {
    let token: String
    let tokenLifetime: Int32?
}

struct EmptyType: Codable { }

struct LocationPoint: Decodable {
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let latitudeString = try container.decode(String.self, forKey: .latitude)
        let longitudeString = try container.decode(String.self, forKey: .longitude)
        
        if let latitude = Double(latitudeString), let longitude = Double(longitudeString) {
            self.latitude = latitude
            self.longitude = longitude
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .latitude,
                in: container,
                debugDescription: "Invalid latitude or longitude format"
            )
        }
    }
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

struct MenuItemPresentable {
    let item: LocationMenuItem
    let imageData: Data?
    let itemCount: Int
}
