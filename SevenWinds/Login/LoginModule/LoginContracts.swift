import UIKit
protocol LoginViewToPresenterProtocol: AnyObject {
    var view: LoginPresenterToViewProtocol? { get set }
    var interactor: LoginPresenterToInteractorProtocol? { get set }
    var router: LoginPresenterToRouterProtocol? { get set }
    
    func login(with credentials: Credentials)
    func pushToRegistration()
}

protocol LoginPresenterToViewProtocol: AnyObject {
    func onLoginSuccess()
    func onLoginError(message: String)
}

protocol LoginPresenterToInteractorProtocol: AnyObject {
    var presenter: LoginInteractorToPresenter? { get set }
    
    func login(with credentials: Credentials)
}

protocol LoginInteractorToPresenter: AnyObject {
    func success(with credentials: Credentials)
    func fail(errorMessage: String)
}

protocol LoginPresenterToRouterProtocol: AnyObject {
    static func createModule(loginHandler: @escaping (Credentials) -> (), apiClient: APIClient, credService: AppStateService) -> UINavigationController
    func pushToRegistration(on view: LoginPresenterToViewProtocol)
    func successfulLogin(with credentials: Credentials)
}
