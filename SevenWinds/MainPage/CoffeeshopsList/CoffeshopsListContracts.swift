import UIKit

protocol CoffeeshopsListViewToPresenterProtocol: AnyObject {
    var view: CoffeeshopsListPresenterToViewProtocol? { get }
    var interactor: CoffeeshopsListPresenterToInteractorProtocol? { get }
    var router: CoffeeshopsListPresenterToRouterProtocol? { get }
    
    func distanceToPoint(_ point: LocationPoint) -> Int?
    
    func viewDidLoad()
    
    func numberOfRowsInSection() -> Int
    func locationForRow(_ row: Int) -> Location?
    
    func didSelectRowAt(index: Int)
    func deselectRowAt(index: Int)
    
    func openMapView()
}

protocol CoffeeshopsListPresenterToViewProtocol: AnyObject {
    func onFetchCoffeeshopsSuccess()
    func onFetchCoffeeshopsFailure(error: String)
    
    func showHUD()
    func hideHUD()
    
    func deselectRowAt(row: Int)
}

protocol CoffeeshopsListPresenterToInteractorProtocol: AnyObject {
    var presenter: CoffeeshopsListInteractorToPresenter? { get }
    
    func loadCoffeeshops()
    func retrieveCoffeeshop(at index: Int) -> Location?
    func getCoffeeshopsCount() -> Int
    func getCoffeeshops() -> [Location]
}

protocol CoffeeshopsListInteractorToPresenter: AnyObject {
    func fetchCoffeeshopsSuccess()
    func fetchCoffeeshopsFailure(errorMessage: String)
}

protocol CoffeeshopsListPresenterToRouterProtocol: AnyObject {
    static func createModule(apiClient: APIClient, credService: AppStateService) -> UINavigationController
    func pushToMapView(on view: CoffeeshopsListPresenterToViewProtocol, with locations: [Location])
    func pushToLocationMenu(on view: CoffeeshopsListPresenterToViewProtocol, with location: Location)
}
