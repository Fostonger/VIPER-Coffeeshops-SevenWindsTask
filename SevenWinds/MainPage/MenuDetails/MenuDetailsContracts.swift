import UIKit

protocol MenuDetailsViewToPresenterProtocol: AnyObject {
    var view: MenuDetailsPresenterToViewProtocol? { get }
    var interactor: MenuDetailsPresenterToInteractorProtocol? { get }
    var router: MenuDetailsPresenterToRouterProtocol? { get }
    
    func viewDidLoad()
    
    func numberOfRowsInSection() -> Int
    func itemForRow(_ row: Int) -> MenuItemPresentable?
    
    func didAddItem(index: Int)
    func didRemoveItem(index: Int)
    
    func openBuyView()
}

protocol MenuDetailsPresenterToViewProtocol: AnyObject {
    func onFetchMenuSuccess()
    func onFetchMenuFailure(error: String)
    
    func showHUD()
    func hideHUD()
    
    func updateItem(row: Int)
}

protocol MenuDetailsPresenterToInteractorProtocol: AnyObject {
    var presenter: MenuDetailsInteractorToPresenter? { get }
    
    func loadMenu(for locationId: Int32)
    
    func loadImageData(for url: URL, completion: @escaping (Result<Data, Error>)->())
}

protocol MenuDetailsInteractorToPresenter: AnyObject {
    func fetchMenuSuccess(with items: [LocationMenuItem])
    func fetchMenuFailure(errorMessage: String)
}

protocol MenuDetailsPresenterToRouterProtocol: AnyObject {
    static func createModule(apiClient: APIClient, credService: AppStateService, locationId: Int32) -> UIViewController
    func pushToBuyView(on view: MenuDetailsPresenterToViewProtocol, with items: [MenuItemPresentable])
}
