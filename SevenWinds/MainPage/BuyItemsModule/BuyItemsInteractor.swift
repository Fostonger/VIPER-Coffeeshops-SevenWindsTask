//
//  CoffeeshopListInteractor.swift
//  SevenWinds
//
//  Created by Булат Мусин on 29.12.2023.
//
import Foundation

class BuyItemsInteractor: BuyItemsPresenterToInteractorProtocol {
    var presenter: BuyItemsInteractorToPresenter?
    
    init(APIClient: APIClient? = nil, credentialsService: AppStateService) { }

    func buyItems(_ items: [LocationMenuItem]) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.presenter?.buyItemsSuccess(waitTime: 15)
        }
    }
}
