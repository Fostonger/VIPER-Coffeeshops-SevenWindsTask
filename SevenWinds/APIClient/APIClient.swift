//
//  APIClient.swift
//  SevenWinds
//
//  Created by Булат Мусин on 25.12.2023.
//

import Alamofire
import Foundation

protocol APIClient {
    func sendRequest<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T, responseType: U.Type, completion: @escaping (Result<U, AFError>) -> Void)
    func sendRequest<U: Decodable>(with endpoint: Endpoint, responseType: U.Type, completion: @escaping (Result<U, AFError>) -> Void)
    func getData(from url: URL, completion: @escaping (Result<Data?, AFError>) -> Void)
}

final class SevenWindsAPIClient: APIClient {
    private let credentialsProvider: AppStateService
    private let encoder: ParameterEncoder
    private let client: Session
    private let queue: DispatchQueue
    
    public init(with client: Session, encoder: ParameterEncoder? = nil, credentialsProvider: AppStateService) {
        self.credentialsProvider = credentialsProvider
        
        let defaultEncoder = JSONParameterEncoder()
        defaultEncoder.encoder.outputFormatting = .prettyPrinted
        self.encoder = encoder != nil ? encoder! : defaultEncoder
        self.client = client
        self.queue = DispatchQueue.global()
    }
    
    public func sendRequest<U: Decodable>(with endpoint: Endpoint, responseType: U.Type, completion: @escaping (Result<U, AFError>) -> Void) {
        _sendRequest(with: endpoint, parameters: Optional<Int>.none, responseType: responseType, completion: completion)
    }
    
    public func sendRequest<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T, responseType: U.Type, completion: @escaping (Result<U, AFError>) -> Void) {
        _sendRequest(with: endpoint, parameters: parameters,
                    responseType: responseType, completion: completion)
    }
    
    public func getData(from url: URL, completion: @escaping (Result<Data?, AFError>) -> Void) {
        client.request(url).response { response in
            completion(response.result)
        }
    }
    
    private func _sendRequest<T: Encodable, U: Decodable>(with endpoint: Endpoint, parameters: T? = nil, responseType: U.Type, completion: @escaping (Result<U, AFError>) -> Void) {
        // Единственный false, по которому можно отлететь - auth required, но token == nil
        guard !endpoint.authRequired || credentialsProvider.token != nil else {
            withTryAuth { [weak self] in
                if self?.credentialsProvider.token == nil {
                    completion(.failure(.sessionTaskFailed(error: SevenWindsAPIError.authNotProvided)))
                }
            }
            return
        }
        
        var headers = endpoint.headers
        
        // был guard, на котором проверили, что если нужен - токен точно есть
        if endpoint.authRequired {
            headers.add(.authorization(bearerToken: credentialsProvider.token!))
        }
        
        client.request(baseUrl + endpoint.getEndpoint(),
                       method: endpoint.method,
                       parameters: parameters,
                       encoder: encoder,
                       headers: headers)
        .validate()
        .responseDecodable(of: U.self) { [weak self] response in
            if let data = response.data {
                print(String(data: data, encoding: .utf8)!)
            }
            if response.error?.responseCode == 401 {
                self?.withTryAuth { [weak self] in
                    self?.sendRequest(with: endpoint, parameters: parameters, responseType: responseType, completion: completion)
                }
                return
            }
            completion(response.result)
        }
    }
    
    private func withTryAuth(completion: @escaping () -> Void) {
        credentialsProvider.setToken("", expirationDate: -1)
        sendRequest(with: AuthEndpoint.login,
                          parameters: credentialsProvider.userCredentials,
                          responseType: AuthResponse.self) { [weak self] result in
            if case .success = result,
               let auth = try? result.get() {
                self?.credentialsProvider.setToken(auth.token, expirationDate: auth.tokenLifetime)
            }
            completion()
        }
    }
    
    private var baseUrl: String {
        "http://147.78.66.203:3210/"
    }
}
