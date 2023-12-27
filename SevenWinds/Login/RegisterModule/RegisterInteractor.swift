//
//  RegisterInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation
import Alamofire

class RegisterInteractor: RegisterPresenterToInteractorProtocol {
    var APIClient: APIClient?
    private var credentialsService: AppStateService
    
    init(APIClient: APIClient? = nil, credentialsService: AppStateService) {
        self.APIClient = APIClient
        self.credentialsService = credentialsService
    }
    
    var presenter: RegisterInteractorToPresenter?
    
    func register(with credentials: Credentials) {
        APIClient?.sendRequest(with: AuthEndpoint.register,
                               parameters: [credentials]) { [weak self] (response: Result<AuthResponse, AFError>) in
            switch response {
            case .success(let auth):
                self?.credentialsService.setCredentials(credentials)
                self?.credentialsService.setToken(auth.token, expirationDate: auth.tokenLifetime)
                self?.presenter?.success(with: credentials)
            case .failure(let failure):
                self?.presenter?.fail(errorMessage: failure.localizedDescription)
            }
        }
    }
}
