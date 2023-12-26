//
//  APIClient.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import Alamofire
import Foundation

final class APIClient {
    private var token: String?
    private var tokenExpirationDate: Date?
    private let encoder: ParameterEncoder
    private let client: Session
    private var credentialsService: AppStateService
    
    public init(with client: Session, service: AppStateService, encoder: ParameterEncoder? = nil, token: String? = nil) {
        self.token = token
        
        let defaultEncoder = JSONParameterEncoder()
        defaultEncoder.encoder.outputFormatting = .prettyPrinted
        self.encoder = encoder != nil ? encoder! : defaultEncoder
        self.client = client
        self.credentialsService = service
    }
    
    public func sendRequest<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: [T]? = nil, completion: @escaping (Result<U, AFError>) -> Void) {
        // Единственный false, по которому можно отлететь - auth required, но token == nil
        guard !endpoint.authRequired || token != nil else {
            completion(.failure(.sessionTaskFailed(error: SevenWindsAPIError.authNotProvided)))
            return
        }
        
        if tokenExpirationDate != nil && tokenExpirationDate! <= .now {
            tryReauth { [weak self] result in
                switch result {
                case .success:
                    self?.sendRequest(with: endpoint, parameters: parameters, completion: completion)
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
            return
        }
        
        var headers = endpoint.headers
        var completion = completion
        
        // был guard, на котором проверили, что если нужен - токен точно есть
        if endpoint.authRequired {
            headers.add(.authorization(bearerToken: token!))
        } else {
            // если токен был нужен, но его не оказалось - пробуем подцепить из респонсов
            completion = { [weak self] result in
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
            completion(response.result)
        }
    }
    
    private func tryReauth(completion: @escaping (Result<Void, AFError>) -> Void) {
        guard let credentials = credentialsService.userCredentials else {
            completion(.failure(.sessionTaskFailed(error: SevenWindsAPIError.authNotProvided)))
            return
        }
        
        sendRequest(with: AuthEndpoint.login,
                    parameters: [credentials]) {[weak self] (result: Result<AuthResponse, AFError>) in
            switch result {
            case .success(let auth):
                self?.token = auth.token
                if let expiration = auth.tokenLifetime {
                    self?.tokenExpirationDate = Date.now + TimeInterval(expiration)
                }
                completion(.success(()))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    
    private var baseUrl: String {
        "http://147.78.66.203:3210/"
    }
}
