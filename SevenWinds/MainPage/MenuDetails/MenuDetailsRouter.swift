//
//  MenuDetailsRouter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation
import UIKit

class MenuDetailsRouter: MenuDetailsPresenterToRouterProtocol {
    private let apiClient: APIClient
    private let credService: AppStateService
    
    static func createModule(apiClient: APIClient, credService: AppStateService, locationId: Int32) -> UIViewController {
        
        let view = MenuDetailsViewController()
        let presenter = MenuDetailsPresenter(with: locationId)
        let interactor = MenuDetailsInteractor(APIClient: apiClient, credentialsService: credService)
        let router = MenuDetailsRouter(apiClient: apiClient, credService: credService)
        
        
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
    
    func pushToBuyView(on view: MenuDetailsPresenterToViewProtocol, with items: [MenuItemPresentable]) {
        let srcVC = view as! UIViewController
        let dstVC = BuyItemsRouter.createModule(items: items,
                                                apiClient: apiClient,
                                                credService: credService)
        srcVC.navigationController?.pushViewController(dstVC, animated: true)
    }
}
