//
//  LoginInteractor.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//
import Foundation
import Alamofire

class LoginInteractor: LoginPresenterToInteractorProtocol {
    var APIClient: APIClient?
    private var credentialsService: AppStateService
    
    init(APIClient: APIClient? = nil, credentialsService: AppStateService) {
        self.APIClient = APIClient
        self.credentialsService = credentialsService
    }
    
    var presenter: LoginInteractorToPresenter?
    
    func login(with credentials: Credentials) {
        APIClient?.sendRequest(with: AuthEndpoint.login,
                               parameters: credentials, responseType: AuthResponse.self) { [weak self] response in
            switch response {
            case .success(let auth):
                self?.presenter?.success(with: credentials)
                self?.credentialsService.setCredentials(credentials)
                self?.credentialsService.setToken(auth.token, expirationDate: auth.tokenLifetime)
            case .failure(let failure):
                self?.presenter?.fail(errorMessage: failure.localizedDescription)
            }
        }
    }
}
