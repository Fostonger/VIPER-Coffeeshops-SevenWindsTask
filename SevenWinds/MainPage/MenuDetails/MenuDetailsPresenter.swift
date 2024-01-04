//
//  MenuDetailsPresenter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation
import UIKit

class MenuDetailsPresenter: MenuDetailsViewToPresenterProtocol {
    var view: MenuDetailsPresenterToViewProtocol?
    var interactor: MenuDetailsPresenterToInteractorProtocol?
    var router: MenuDetailsPresenterToRouterProtocol?
    
    private let locationId: Int32
    
    private var items: [MenuItemPresentable] = []
    
    init(with locationId: Int32) {
        self.locationId = locationId
    }
    
    func numberOfRowsInSection() -> Int {
        items.count
    }
    
    func itemForRow(_ row: Int) -> MenuItemPresentable? {
        guard items.count > row else { return nil }
        return items[row]
    }
    
    func viewDidLoad() {
        view?.showHUD()
        interactor?.loadMenu(for: locationId)
    }
    
    func didAddItem(index: Int) {
        items[index] = MenuItemPresentable(item: items[index].item,
                                           imageData: items[index].imageData,
                                           itemCount: items[index].itemCount + 1)
        view?.updateItem(row: index)
    }
    
    func didRemoveItem(index: Int) {
        guard items[index].itemCount > 0 else { return }
        
        items[index] = MenuItemPresentable(item: items[index].item,
                                           imageData: items[index].imageData,
                                           itemCount: items[index].itemCount - 1)
        view?.updateItem(row: index)
    }
    
    func openBuyView() {
        router?.pushToBuyView(on: view!, with: items.filter{ $0.itemCount > 0 })
    }
}

extension MenuDetailsPresenter: MenuDetailsInteractorToPresenter {
    func getImageDataSuccess(for index: Int, image: Data) {
        guard items.count > index else { return }
        
        items[index] = MenuItemPresentable(item: items[index].item,
                                           imageData: image,
                                           itemCount: items[index].itemCount)
        
        view?.updateItem(row: index)
    }
    
    func getImageDataFailure(for index: Int, message: String) {
        guard items.count > index else { return }
        
        items[index] = MenuItemPresentable(
            item: items[index].item,
            imageData: UIImage.remove.cgImage?.dataProvider?.data as? Data ?? Data(),
            itemCount: items[index].itemCount
        )
        
        view?.onFetchMenuFailure(error: message)
        
        view?.updateItem(row: index)
    }
    
    func fetchMenuSuccess(with items: [LocationMenuItem]) {
        view?.hideHUD()
        self.items = items.map{ MenuItemPresentable(item: $0, imageData: nil, itemCount: 0) }
        view?.onFetchMenuSuccess()
        
        items.enumerated().forEach{ (index, item) in
            guard let url = item.imageURL else { return }
            interactor?.loadImageData(for: url) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.getImageDataSuccess(for: index, image: data)
                case .failure(let failure):
                    self?.getImageDataFailure(for: index, message: failure.localizedDescription)
                }
            }
        }
    }
    
    func fetchMenuFailure(errorMessage: String) {
        view?.hideHUD()
        view?.onFetchMenuFailure(error: errorMessage)
    }
}
