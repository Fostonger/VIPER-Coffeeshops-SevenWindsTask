import UIKit

protocol CoffeeshopsListMapViewViewToPresenterProtocol: AnyObject {
    var view: CoffeeshopsListMapViewPresenterToViewProtocol? { get }
    var router: CoffeeshopsListMapViewPresenterToRouterProtocol? { get }
    
    var locations: [Location] { get }
    
    func didSelectLocation(_ location: Location)
}

protocol CoffeeshopsListMapViewPresenterToViewProtocol: AnyObject {
}


protocol CoffeeshopsListMapViewPresenterToRouterProtocol: AnyObject {
    static func createModule(locations: [Location], apiClient: APIClient, credService: AppStateService) -> UIViewController
    func pushToLocationMenu(on view: CoffeeshopsListMapViewPresenterToViewProtocol, with location: Location)
}
