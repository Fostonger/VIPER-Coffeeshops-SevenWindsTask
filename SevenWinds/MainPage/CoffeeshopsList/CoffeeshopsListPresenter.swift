//
//  CoffeeshopsListPresenter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation

class CoffeeshopsListPresenter: CoffeeshopsListViewToPresenterProtocol {
    
    var view: CoffeeshopsListPresenterToViewProtocol?
    var interactor: CoffeeshopsListPresenterToInteractorProtocol?
    var router: CoffeeshopsListPresenterToRouterProtocol?
    
    func numberOfRowsInSection() -> Int {
        interactor?.getCoffeeshopsCount() ?? 0
    }
    
    func locationForRow(_ row: Int) -> Location? {
        interactor?.retrieveCoffeeshop(at: row)
    }
    
    func viewDidLoad() {
        view?.showHUD()
        interactor?.loadCoffeeshops()
    }
    
    func didSelectRowAt(index: Int) {
        guard let view = view,
              let location = interactor?.retrieveCoffeeshop(at: index) else {
            return
        }
        router?.pushToLocationMenu(on: view, with: location)
    }
    
    func deselectRowAt(index: Int) {
        view?.deselectRowAt(row: index)
    }
}

extension CoffeeshopsListPresenter: CoffeeshopsListInteractorToPresenter {
    func fetchCoffeeshopsSuccess() {
        view?.hideHUD()
        view?.onFetchCoffeeshopsSuccess()
    }
    
    func fetchCoffeeshopsFailure(errorMessage: String) {
        view?.hideHUD()
        view?.onFetchCoffeeshopsFailure(error: errorMessage)
    }
}
