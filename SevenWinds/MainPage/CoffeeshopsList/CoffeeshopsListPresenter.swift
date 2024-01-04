//
//  CoffeeshopsListPresenter.swift
//  SevenWinds
//
//  Created by Булат Мусин on 30.12.2023.
//

import Foundation
import CoreLocation

class CoffeeshopsListPresenter: NSObject, CoffeeshopsListViewToPresenterProtocol {
    
    var view: CoffeeshopsListPresenterToViewProtocol?
    var interactor: CoffeeshopsListPresenterToInteractorProtocol?
    var router: CoffeeshopsListPresenterToRouterProtocol?
    
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    func numberOfRowsInSection() -> Int {
        interactor?.getCoffeeshopsCount() ?? 0
    }
    
    func locationForRow(_ row: Int) -> Location? {
        interactor?.retrieveCoffeeshop(at: row)
    }
    
    func viewDidLoad() {
        view?.showHUD()
        interactor?.loadCoffeeshops()
        setupLocation()
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
    
    func openMapView() {
        router?.pushToMapView(on: view!, with: interactor?.getCoffeeshops() ?? [])
    }
    
    func distanceToPoint(_ point: LocationPoint) -> Int? {
        guard let userLocation = userLocation else { return nil }
        let pointToLocation = CLLocation(latitude: point.latitude, longitude: point.longitude)
        return Int(pointToLocation.distance(from: userLocation).magnitude)
    }
    
    private func setupLocation() {
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

extension CoffeeshopsListPresenter: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = manager.location else { return }
        userLocation = locValue
        view?.onFetchCoffeeshopsSuccess()
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
