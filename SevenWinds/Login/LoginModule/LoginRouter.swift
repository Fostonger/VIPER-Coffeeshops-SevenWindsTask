//
//  LoginRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation
import UIKit

class LoginRouter: LoginPresenterToRouterProtocol {
    var loginHandler: (Credentials) -> ()
    private let apiClient: APIClient
    private let credService: AppStateService
    
    static func createModule(loginHandler: @escaping (Credentials) -> (), apiClient: APIClient, credService: AppStateService) -> UINavigationController {
        
        let view = LoginViewController()
        let presenter = LoginPresenter()
        let interactor = LoginInteractor(APIClient: apiClient, credentialsService: credService)
        let router = LoginRouter(loginHandler: loginHandler, apiClient: apiClient, credService: credService)
        let navigationController = UINavigationController(rootViewController: view)
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return navigationController
    }
    
    private init(loginHandler: @escaping (Credentials) -> Void, apiClient: APIClient, credService: AppStateService) {
        self.loginHandler = loginHandler
        self.apiClient = apiClient
        self.credService = credService
    }
    
    func successfulLogin(with credentials: Credentials) {
        loginHandler(credentials)
    }
    
    func pushToRegistration(on view: LoginPresenterToViewProtocol) {
        let registerVC = RegisterRouter.createModule(loginHandler: loginHandler, apiClient: apiClient, credService: credService)
        
        let viewController = view as! LoginViewController
        viewController.navigationController?.pushViewController(registerVC, animated: true)
    }
}
