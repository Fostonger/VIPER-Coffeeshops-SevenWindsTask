//
//  CoffeeshopsListMapViewPresenter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation

class CoffeeshopsListMapViewPresenter: CoffeeshopsListMapViewViewToPresenterProtocol {
    var view: CoffeeshopsListMapViewPresenterToViewProtocol?
    var router: CoffeeshopsListMapViewPresenterToRouterProtocol?
    
    var locations: [Location] = []
    
    func didSelectLocation(_ location: Location) {
        router?.pushToLocationMenu(on: view!, with: location)
    }
}
