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
            completion(.failure(.sessionTaskFailed(error: SevenWindsAPIError.authNotProvided)))
            return
        }
        
        if let expired = credentialsProvider.expirationDate, expired <= .now {
            completion(.failure(.sessionTaskFailed(error: SevenWindsAPIError.authNotProvided)))
            return
        }
        
        var headers = endpoint.headers
        var additionalCompletion = completion
        
        // был guard, на котором проверили, что если нужен - токен точно есть
        if endpoint.authRequired {
            headers.add(.authorization(bearerToken: credentialsProvider.token!))
        } else {
            // если токен был нужен, но его не оказалось - пробуем подцепить из респонсов
            additionalCompletion = { [weak self] result in
                if case .success = result,
                   let auth = try? result.get() as? AuthResponse {
                    self?.credentialsProvider.setToken(auth.token, expirationDate: auth.tokenLifetime)
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
        .responseDecodable(of: U.self) { [weak self] response in
            if let data = response.data {
                print(String(data: data, encoding: .utf8)!)
            }
            if response.error?.responseCode == 401 {
                self?.sendRequest(with: AuthEndpoint.login,
                                  parameters: self?.credentialsProvider.userCredentials,
                                  responseType: AuthResponse.self) { _ in
                    self?.sendRequest(with: endpoint, parameters: parameters, responseType: responseType, completion: completion)
                }
                return
            }
            additionalCompletion(response.result)
        }
    }
    
    private var baseUrl: String {
        "http://147.78.66.203:3210/"
    }
}
