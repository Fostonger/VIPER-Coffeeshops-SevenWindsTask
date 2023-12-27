//
//  APIClient.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import Alamofire
import Foundation

protocol APIClient {
    func sendRequest<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T?, responseType: U.Type, completion: @escaping (Result<U, AFError>) -> Void)
}

final class SevenWindsAPIClient: APIClient {
    private var token: String?
    private var tokenExpirationDate: Date?
    private let encoder: ParameterEncoder
    private let client: Session
    
    public init(with client: Session, encoder: ParameterEncoder? = nil, token: String? = nil) {
        self.token = token
        
        let defaultEncoder = JSONParameterEncoder()
        defaultEncoder.encoder.outputFormatting = .prettyPrinted
        self.encoder = encoder != nil ? encoder! : defaultEncoder
        self.client = client
    }
    
    public func sendRequest<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T? = nil, responseType: U.Type, completion: @escaping (Result<U, AFError>) -> Void) {
        // Единственный false, по которому можно отлететь - auth required, но token == nil
        guard !endpoint.authRequired || token != nil else {
            completion(.failure(.sessionTaskFailed(error: SevenWindsAPIError.authNotProvided)))
            return
        }
        
        if tokenExpirationDate != nil && tokenExpirationDate! <= .now {
            completion(.failure(.sessionTaskFailed(error: SevenWindsAPIError.authNotProvided)))
            return
        }
        
        var headers = endpoint.headers
        var additionalCompletion = completion
        
        // был guard, на котором проверили, что если нужен - токен точно есть
        if endpoint.authRequired {
            headers.add(.authorization(bearerToken: token!))
        } else {
            // если токен был нужен, но его не оказалось - пробуем подцепить из респонсов
            additionalCompletion = { [weak self] result in
                if case .success = result,
                   let auth = try? result.get() as? AuthResponse {
                    self?.token = auth.token
                    if let lifetime = auth.tokenLifetime {
                        self?.tokenExpirationDate = Date.now + TimeInterval(lifetime)
                    }
                }
                completion(result)
            }
        }
        
        client.request(baseUrl + endpoint.getEndpoint(),
                       method: endpoint.method,
                       parameters: parameters,
                       encoder: encoder,
                       headers: headers)
        .validate()
        .responseDecodable(of: U.self) {response in
            additionalCompletion(response.result)
        }
    }
    
    private var baseUrl: String {
        "http://147.78.66.203:3210/"
    }
}
