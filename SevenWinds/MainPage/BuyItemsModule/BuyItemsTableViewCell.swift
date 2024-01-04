//
//  CoffeeshopTableViewCell.swift
//  SevenWinds
//
//  Created by Булат Мусин on 29.12.2023.
//

import UIKit

class BuyItemTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.bold?.withSize(18)
        label.textColor = SevenWindsColors.brown.uiColor
        label.numberOfLines = 0
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.font?.withSize(14)
        label.textColor = SevenWindsColors.secondaryBrown.uiColor
        return label
    }()
    
    private let brownView: UIView = {
        let view = UIView()
        view.backgroundColor = SevenWindsColors.lightBrown.uiColor
        view.layer.cornerRadius = 5
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.25
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.bold?.withSize(14)
        label.textColor = SevenWindsColors.brown.uiColor
        label.textAlignment = .center
        return label
    }()
    
    private let countLabelSize: CGSize = {
        let font = SevenWindsFonts.sfUiDisplay.bold!
        let fontAttributes = [NSAttributedString.Key.font: font]
        let text = "999+"
        return (text as NSString).size(withAttributes: fontAttributes)
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = SevenWindsColors.brown.uiColor
        button.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(.minus.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = SevenWindsColors.brown.uiColor
        button.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupView(with item: MenuItemPresentable) {
        titleLabel.text = item.item.name
        priceLabel.text = MainPageLocalization.price(rub: Int(item.item.price ?? 0)).localized
        countLabel.text = item.itemCount <= 999 ? "\(item.itemCount)" : "999+"
    }
    
    private func setupUI() {
        contentView.addSubview(brownView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(countLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(minusButton)
        backgroundColor = .clear
        
        brownView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.bottom.left.right.equalToSuperview().inset(3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(21)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(9)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(21)
            make.width.equalTo(titleLabel.snp.width)
        }
        
        minusButton.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(3)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(minusButton.snp.right).offset(9)
            make.centerY.equalToSuperview()
            make.height.equalTo(countLabelSize.height)
            make.width.equalTo(countLabelSize.width)
        }
        
        plusButton.snp.makeConstraints { make in
            make.left.equalTo(countLabel.snp.right).offset(9)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(10)
        }
        
    }
}
