//
//  CoffeeshopListInteractor.swift
//  SevenWinds
//
//  Created by Булат Мусин on 29.12.2023.
//

class CoffeeshopsListInteractor: CoffeeshopsListPresenterToInteractorProtocol {
    var presenter: CoffeeshopsListInteractorToPresenter?
    
    var APIClient: APIClient?
    private var credentialsService: AppStateService
    private var locations: [Location] = []
    
    init(APIClient: APIClient? = nil, credentialsService: AppStateService) {
        self.APIClient = APIClient
        self.credentialsService = credentialsService
    }
    
    func loadCoffeeshops() {
        APIClient?.sendRequest(with: LocationEndpoint.fetchLocations,
                               responseType: [Location].self) { [weak self] response in
            switch response {
            case .success(let locations):
                self?.locations = locations
                self?.presenter?.fetchCoffeeshopsSuccess()
            case .failure(let failure):
                self?.presenter?.fetchCoffeeshopsFailure(errorMessage: failure.localizedDescription)
            }
        }
    }
    
    func retrieveCoffeeshop(at index: Int) -> Location? {
        guard locations.count > index else {
            return nil
        }
        return locations[index]
    }
    
    func getCoffeeshopsCount() -> Int {
        locations.count
    }
    
    func getCoffeeshops() -> [Location] {
        locations
    }
    
}
