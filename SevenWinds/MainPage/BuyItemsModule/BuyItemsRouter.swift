//
//  BuyItemsRouter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import UIKit

class BuyItemsRouter: BuyItemsPresenterToRouterProtocol {
    private let apiClient: APIClient
    private let credService: AppStateService
    
    static func createModule(items: [MenuItemPresentable], apiClient: APIClient, credService: AppStateService) -> UIViewController {
        
        let view = BuyItemsViewController()
        let presenter = BuyItemsPresenter(items: items)
        let interactor = BuyItemsInteractor(APIClient: apiClient, credentialsService: credService)
        let router = BuyItemsRouter(apiClient: apiClient, credService: credService)
        
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    private init(apiClient: APIClient, credService: AppStateService) {
        self.apiClient = apiClient
        self.credService = credService
    }
}
