//
//  RegisterRouter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation
import UIKit

class RegisterRouter: RegisterPresenterToRouterProtocol {
    var loginHandler: (Credentials) -> ()
    
    static func createModule(loginHandler: @escaping (Credentials) -> (), apiClient: APIClient, credService: AppStateService) -> UIViewController {
        
        let view = RegisterViewController()
        let presenter = RegisterPresenter()
        let interactor = RegisterInteractor(APIClient: apiClient, credentialsService: credService)
        let router = RegisterRouter(loginHandler: loginHandler)
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    private init(loginHandler: @escaping (Credentials) -> Void) {
        self.loginHandler = loginHandler
    }
    
    func successfulRegistration(with credentials: Credentials) {
        loginHandler(credentials)
    }
}
