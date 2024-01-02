//
//  CoffeeshopListInteractor.swift
//  SevenWinds
//
//  Created by Булат Мусин on 29.12.2023.
//

import Foundation

class MenuDetailsInteractor: MenuDetailsPresenterToInteractorProtocol {
    
    var presenter: MenuDetailsInteractorToPresenter?
    
    var APIClient: APIClient?
    private var credentialsService: AppStateService
    
    init(APIClient: APIClient? = nil, credentialsService: AppStateService) {
        self.APIClient = APIClient
        self.credentialsService = credentialsService
    }
    
    func loadMenu(for locationId: Int32) {
        APIClient?.sendRequest(with: LocationEndpoint.getLocationById(id: locationId),
                               responseType: [LocationMenuItem].self) { [weak self] response in
            switch response {
            case .success(let items):
                self?.presenter?.fetchMenuSuccess(with: items)
            case .failure(let failure):
                self?.presenter?.fetchMenuFailure(errorMessage: failure.localizedDescription)
            }
        }
    }
    
    func loadImageData(for url: URL, completion: @escaping (Result<Data, Error>)->() ) {
        APIClient?.getData(from: url) { response in
            switch response {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(SevenWindsAPIError.imageDataError))
                    return
                }
                completion(.success(data))
            case .failure(_):
                completion(.failure(SevenWindsAPIError.imageDownloadError))
            }
        }
    }
    
}
