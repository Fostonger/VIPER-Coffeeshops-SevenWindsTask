//
//  BuyItemsPresenter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation

class BuyItemsPresenter: BuyItemsViewToPresenterProtocol {
    var view: BuyItemsPresenterToViewProtocol?
    var interactor: BuyItemsPresenterToInteractorProtocol?
    var router: BuyItemsPresenterToRouterProtocol?
    
    private var items: [MenuItemPresentable]
    
    init(items: [MenuItemPresentable]) {
        self.items = items
    }
    
    func numberOfRowsInSection() -> Int {
        items.count
    }
    
    func viewDidLoad() {}
    
    func itemForRow(_ row: Int) -> MenuItemPresentable? {
        items[row]
    }
    
    func didAddItemAt(index: Int) {
        items[index] = MenuItemPresentable(item: items[index].item,
                                           imageData: items[index].imageData,
                                           itemCount: items[index].itemCount + 1)
        view?.reloadItemCount(row: index)
    }
    
    func didRemoveItemAt(index: Int) {
        guard items[index].itemCount > 0 else { return }
        items[index] = MenuItemPresentable(item: items[index].item,
                                           imageData: items[index].imageData,
                                           itemCount: items[index].itemCount - 1)
        view?.reloadItemCount(row: index)
    }
    
    func buyItems() {
        self.view?.showHUD()
        interactor?.buyItems(items.map(\.item))
    }
}

extension BuyItemsPresenter: BuyItemsInteractorToPresenter {
    func buyItemsSuccess(waitTime: Int) {
        DispatchQueue.main.async {
            self.view?.hideHUD()
            let message = MainPageLocalization.waitTime(waitTime: waitTime).localized
            self.view?.onBuyItemsSuccess(message: message)
        }
    }
    
    func buyItemsFailure(errorMessage: String) {
        DispatchQueue.main.async {
            self.view?.hideHUD()
            self.view?.onBuyItemsFailure(error: errorMessage)
        }
    }
}
