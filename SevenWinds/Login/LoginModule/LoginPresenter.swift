//
//  LoginPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class LoginPresenter: LoginViewToPresenterProtocol {
    var view: LoginPresenterToViewProtocol?
    var interactor: LoginPresenterToInteractorProtocol?
    var router: LoginPresenterToRouterProtocol?
    
    func login(with credentials: Credentials) {
        interactor?.login(with: credentials)
    }
    
    func pushToRegistration() {
        guard let view = view else { return }
        router?.pushToRegistration(on: view)
    }
}

extension LoginPresenter: LoginInteractorToPresenter {
    func success(with credentials: Credentials) {
        router?.successfulLogin(with: credentials)
    }
    
    func fail(errorMessage: String) {
        print("erorr \(errorMessage)")
        view?.onLoginError(message: errorMessage)
    }
}
