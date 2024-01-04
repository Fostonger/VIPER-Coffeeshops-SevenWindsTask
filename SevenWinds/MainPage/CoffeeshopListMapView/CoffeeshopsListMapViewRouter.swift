//
//  CoffeeshopsListMapViewRouter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation
import UIKit

class CoffeeshopsListMapViewRouter: CoffeeshopsListMapViewPresenterToRouterProtocol {
    private let apiClient: APIClient
    private let credService: AppStateService
    
    static func createModule(locations: [Location], apiClient: APIClient, credService: AppStateService) -> UIViewController {
        
        let view = CoffeeshopsListMapViewViewController()
        let presenter = CoffeeshopsListMapViewPresenter()
        presenter.locations = locations
        let router = CoffeeshopsListMapViewRouter(apiClient: apiClient, credService: credService)
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view
    }
    
    private init(apiClient: APIClient, credService: AppStateService) {
        self.apiClient = apiClient
        self.credService = credService
    }
    
    func pushToLocationMenu(on view: CoffeeshopsListMapViewPresenterToViewProtocol, with location: Location) {
        guard let vc = view as? UIViewController, let id = location.id else {
            print("Unexpectedly found nil in location's Id field")
            return
        }
        let detailsVC = MenuDetailsRouter.createModule(apiClient: apiClient, credService: credService, locationId: id)
        vc.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
