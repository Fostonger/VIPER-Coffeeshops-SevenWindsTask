import UIKit
import SnapKit
import PKHUD

class MenuDetailsViewController: UIViewController {
    
    var presenter : MenuDetailsViewToPresenterProtocol?
    
    private let cellId = "menuItem"
    private let sectionInsets = UIEdgeInsets(top: 6.5, left: 6.5, bottom: 6.5, right: 6.5)
    let layout = UICollectionViewFlowLayout.init()
    
    private lazy var collectionView: UICollectionView = {
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 13
        layout.minimumLineSpacing = 13
        layout.sectionInset = sectionInsets
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collection.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(15)
        }
        
        title = MainPageLocalization.menuTitle.localized
    }
}

extension MenuDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                       for: indexPath) as? ItemCollectionViewCell,
              let item = presenter?.itemForRow(indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.adoptBoundingWidth(
            (collectionView.frame.width - (sectionInsets.left + sectionInsets.right + 1) * 2) / 2
        )
        cell.setupView(with: item)
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    @objc func addItem(sender : UIButton) {
        presenter?.didAddItem(index: sender.tag)
    }
    
    @objc func removeItem(sender : UIButton) {
        presenter?.didRemoveItem(index: sender.tag)
    }
}

extension MenuDetailsViewController: MenuDetailsPresenterToViewProtocol {
    func updateItem(row: Int) {
        collectionView.reloadItems(at: [IndexPath(item: row, section: 0)])
    }
    
    func onFetchMenuSuccess() {
        collectionView.reloadData()
    }
    
    func onFetchMenuFailure(error: String) {
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
    
}
