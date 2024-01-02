//
//  CoffeeshopsListRouter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation
import UIKit

class CoffeeshopsListRouter: CoffeeshopsListPresenterToRouterProtocol {
    private let apiClient: APIClient
    private let credService: AppStateService
    
    static func createModule(apiClient: APIClient, credService: AppStateService) -> UINavigationController {
        
        let view = CoffeeshopsListViewController()
        let presenter = CoffeeshopsListPresenter()
        let interactor = CoffeeshopsListInteractor(APIClient: apiClient, credentialsService: credService)
        let router = CoffeeshopsListRouter(apiClient: apiClient, credService: credService)
        let navigationController = UINavigationController(rootViewController: view)
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        if let customFont = SevenWindsFonts.sfUiDisplay.bold {
            navigationController.navigationBar.titleTextAttributes = [
                .font: customFont.withSize(18),
                .foregroundColor: SevenWindsColors.brown.uiColor
            ]
        } else {
            navigationController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold),
                NSAttributedString.Key.foregroundColor: SevenWindsColors.brown.uiColor
            ]
        }
        
        return navigationController
    }
    
    private init(apiClient: APIClient, credService: AppStateService) {
        self.apiClient = apiClient
        self.credService = credService
    }
    
    func pushToMapView(on view: CoffeeshopsListPresenterToViewProtocol, with locations: [Location]) {
        print("TODO: map view")
    }
    
    func pushToLocationMenu(on view: CoffeeshopsListPresenterToViewProtocol, with location: Location) {
        guard let vc = view as? UIViewController, let id = location.id else {
            print("Unexpectedly found nil in location's Id field")
            return
        }
        let detailsVC = MenuDetailsRouter.createModule(apiClient: apiClient, credService: credService, locationId: id)
        vc.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
