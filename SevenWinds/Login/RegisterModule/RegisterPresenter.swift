//
//  RegisterPresenter.swift
//  StartIt
//
//  Created by Булат Мусин on 27.10.2023.
//

import Foundation

class RegisterPresenter: RegisterViewToPresenterProtocol {
    var view: RegisterPresenterToViewProtocol?
    var interactor: RegisterPresenterToInteractorProtocol?
    var router: RegisterPresenterToRouterProtocol?
    
    func register(with credentials: Credentials) {
        interactor?.register(with: credentials)
    }
}

extension RegisterPresenter: RegisterInteractorToPresenter {
    func success(with credentials: Credentials) {
        router?.successfulRegistration(with: credentials)
    }
    
    func fail(errorMessage: String) {
        print("erorr \(errorMessage)")
        view?.onRegisterError(message: errorMessage)
    }
}
