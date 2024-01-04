import UIKit
import SnapKit
import PKHUD

class BuyItemsViewController: UIViewController {
    
    var presenter : BuyItemsViewToPresenterProtocol?
    
    private let cellId = "buyItemCell"
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(BuyItemTableViewCell.self, forCellReuseIdentifier: cellId)
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        table.isScrollEnabled = false
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private let buyButton = SWButton()
    private let successLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.font?.withSize(24)
        label.textColor = SevenWindsColors.brown.uiColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let successLabelHeight = successLabel.sizeThatFits(
            CGSize(width: successLabel.frame.width, height: 0)
        ).height

        tableHeight?.layoutConstraints[0].constant = tableView.contentSize.height +
                                                      tableView.contentInset.top +
                                                      tableView.contentInset.bottom +
                                                      (tableView.tableHeaderView?.frame.height ?? 0)


        let equalSpacing = (buyButton.frame.minY - tableView.frame.minY - (tableHeight?.layoutConstraints[0].constant ?? 0) - successLabelHeight)/2
        
        
        labdab?.layoutConstraints[0].constant = equalSpacing

        buyButton.snp.updateConstraints { make in
            make.top
                .equalTo(successLabel.snp.bottom)
                .offset(equalSpacing)
                .priority(.required)
        }
    }
    
    private var labdab: Constraint?
    private var tableHeight: Constraint?
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(successLabel)
        view.addSubview(buyButton)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).inset(15)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(10)
            tableHeight = make.height
                .equalTo(0)
                .constraint
        }
        
        successLabel.snp.makeConstraints { make in
            labdab = make.top
                .equalTo(tableView.snp.bottom)
                .inset(15)
                .priority(.required)
                .constraint
            make.right.equalToSuperview().inset(13)
            make.left.equalToSuperview().offset(13)
        }
        
        buyButton.snp.makeConstraints { make in
            make.top
                .equalTo(successLabel.snp.bottom)
                .inset(labdab!.layoutConstraints[0].constant)
                .priority(.required)
            make.right.equalToSuperview().inset(18)
            make.left.equalToSuperview().offset(18)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(48)
        }
        
        title = MainPageLocalization.buyViewTitle.localized
        buyButton.addTarget(self, action: #selector(buyItems), for: .touchUpInside)
        buyButton.setTitle(MainPageLocalization.buyButtonTitle.localized, for: .normal)
    }
    
    @objc private func buyItems() {
        buyButton.isEnabled = false
        presenter?.buyItems()
    }
}

extension BuyItemsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                       for: indexPath) as? BuyItemTableViewCell,
              let location = presenter?.itemForRow(indexPath.row) else {
            return UITableViewCell()
        }
        cell.setupView(with: location)
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
    
    
    @objc func addItem(sender : UIButton) {
        presenter?.didAddItemAt(index: sender.tag)
    }
    
    @objc func removeItem(sender : UIButton) {
        presenter?.didRemoveItemAt(index: sender.tag)
    }
}

extension BuyItemsViewController: BuyItemsPresenterToViewProtocol {
    func onBuyItemsSuccess(message: String) {
        successLabel.text = message
    }
    
    func showHUD() {
        HUD.show(.progress, onView: self.view)
    }
    
    func hideHUD() {
        HUD.hide()
    }
    
    func onBuyItemsFailure(error: String) {
        let alert = UIAlertController(title: "Ошибка во время оформления заказа",
                                      message: error,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadItemCount(row: Int) {
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
    }
}
