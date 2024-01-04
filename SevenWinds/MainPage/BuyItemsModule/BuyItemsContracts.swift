import UIKit

protocol BuyItemsViewToPresenterProtocol: AnyObject {
    var view: BuyItemsPresenterToViewProtocol? { get }
    var interactor: BuyItemsPresenterToInteractorProtocol? { get }
    var router: BuyItemsPresenterToRouterProtocol? { get }
    
    func viewDidLoad()
    
    func numberOfRowsInSection() -> Int
    func itemForRow(_ row: Int) -> MenuItemPresentable?
    
    func didAddItemAt(index: Int)
    func didRemoveItemAt(index: Int)
    
    func buyItems()
}

protocol BuyItemsPresenterToViewProtocol: AnyObject {
    func onBuyItemsSuccess(message: String)
    func onBuyItemsFailure(error: String)
    
    func showHUD()
    func hideHUD()
    
    func reloadItemCount(row: Int)
}

protocol BuyItemsPresenterToInteractorProtocol: AnyObject {
    var presenter: BuyItemsInteractorToPresenter? { get }
    
    func buyItems(_ items: [LocationMenuItem])
}

protocol BuyItemsInteractorToPresenter: AnyObject {
    func buyItemsSuccess(waitTime: Int)
    func buyItemsFailure(errorMessage: String)
}

protocol BuyItemsPresenterToRouterProtocol: AnyObject {
    static func createModule(items: [MenuItemPresentable], apiClient: APIClient, credService: AppStateService) -> UIViewController
}
