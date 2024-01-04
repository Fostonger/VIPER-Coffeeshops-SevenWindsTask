import UIKit
import SnapKit
import PKHUD
import YandexMapsMobile

class CoffeeshopsListMapViewViewController: UIViewController {
    
    var presenter : CoffeeshopsListMapViewViewToPresenterProtocol?
    
    private lazy var mapView: YMKMapView = {
        let table = YMKMapView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    private func setupUI() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).inset(15)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: 59.935493, longitude: 30.327392),
                zoom: 15,
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
            cameraCallback: nil)
        
        presenter?.locations.forEach(setupPlacemark)
        
        title = MainPageLocalization.nearbyLocationsTitle.localized
    }
    
    private func setupPlacemark(_ location: Location) {
        let image = UIImage(named: "coffee") ?? UIImage()
        let placemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        placemark.geometry = YMKPoint(latitude: location.point.latitude,
                                      longitude: location.point.latitude)
        placemark.setIconWith(image)
        placemark.setTextWithText(
            location.name,
            style: YMKTextStyle(
                size: 10.0,
                color: .black,
                outlineColor: SevenWindsColors.brown.uiColor,
                placement: .bottom,
                offset: 0.0,
                offsetFromIcon: true,
                textOptional: false
            )
        )
        
        placemark.addTapListener(with: self)
    }
}

extension Double {
    func equalToDouble(_ b: Double) -> Bool {
        let fab = fabs(self - b)
        return fabs(self - b) < 0.05
    }
}

extension CoffeeshopsListMapViewViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        if let location = presenter?.locations.first(where: { $0.point.latitude.equalToDouble(point.latitude) && $0.point.longitude.equalToDouble(point.longitude) }) {
            presenter?.didSelectLocation(location)
        }
        return true
    }
    
}

extension CoffeeshopsListMapViewViewController: CoffeeshopsListMapViewPresenterToViewProtocol {
}
