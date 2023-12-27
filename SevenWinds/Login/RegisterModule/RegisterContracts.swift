import UIKit

protocol RegisterViewToPresenterProtocol: AnyObject {
    var view: RegisterPresenterToViewProtocol? {get set}
    var interactor: RegisterPresenterToInteractorProtocol? {get set}
    var router: RegisterPresenterToRouterProtocol? {get set}
    
    func register(with credentials: Credentials)
}

protocol RegisterPresenterToViewProtocol: AnyObject {
    func onRegisterSuccess()
    func onRegisterError(message: String)
}

protocol RegisterPresenterToInteractorProtocol: AnyObject {
    var presenter: RegisterInteractorToPresenter? { get set }
    
    func register(with credentials: Credentials)
}

protocol RegisterInteractorToPresenter: AnyObject {
    func success(with credentials: Credentials)
    func fail(errorMessage: String)
}


protocol RegisterPresenterToRouterProtocol: AnyObject {
    static func createModule(loginHandler: @escaping (Credentials) -> (), apiClient: APIClient, credService: AppStateService) -> UIViewController
    func successfulRegistration(with credentials: Credentials)
}
