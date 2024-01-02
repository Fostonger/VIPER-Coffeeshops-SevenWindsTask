import UIKit
import SnapKit
import PKHUD

class CoffeeshopsListViewController: UIViewController {
    
    var presenter : CoffeeshopsListViewToPresenterProtocol?
    
    private let cellId = "coffeeLocation"
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CoffeeshopTableViewCell.self, forCellReuseIdentifier: cellId)
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(15)
        }
        
        title = MainPageLocalization.nearbyLocationsTitle.localized
    }
}

extension CoffeeshopsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                       for: indexPath) as? CoffeeshopTableViewCell,
              let location = presenter?.locationForRow(indexPath.row) else {
            return UITableViewCell()
        }
        cell.setupView(with: location)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(index: indexPath.row)
        presenter?.deselectRowAt(index: indexPath.row)
    }
}

extension CoffeeshopsListViewController: CoffeeshopsListPresenterToViewProtocol {
    func onFetchCoffeeshopsSuccess() {
        tableView.reloadData()
    }
    
    func onFetchCoffeeshopsFailure(error: String) {
        let alert = UIAlertController(title: "Ошибка во время сбора данных о кофейнях",
                                      message: error,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showHUD() {
        HUD.show(.progress, onView: self.view)
    }
    
    func hideHUD() {
        HUD.hide()
    }
    
    func deselectRowAt(row: Int) {
        tableView.deselectRow(at: IndexPath(row: row, section: 0), animated: true)
    }
}
