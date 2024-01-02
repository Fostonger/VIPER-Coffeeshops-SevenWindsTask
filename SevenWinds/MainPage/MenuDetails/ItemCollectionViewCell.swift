//
//  CoffeeshopTableViewCell.swift
//  SevenWinds
//
//  Created by Булат Мусин on 29.12.2023.
//

import UIKit

protocol BoundingWidthAdoptable {
    func adoptBoundingWidth(_ width: CGFloat)
}

class ItemCollectionViewCell: UICollectionViewCell, BoundingWidthAdoptable {
    private var boundingWidth: CGFloat = 0
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.bold?.withSize(15)
        label.textColor = SevenWindsColors.secondaryBrown.uiColor
        label.numberOfLines = 1
        return label
    }()
    
    private let countLabelSize: CGSize = {
        let font = SevenWindsFonts.sfUiDisplay.font!
        let fontAttributes = [NSAttributedString.Key.font: font]
        let text = "9+"
        return (text as NSString).size(withAttributes: fontAttributes)
    }()
    
    private let imageView = UIImageView()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.bold?.withSize(14)
        label.textColor = SevenWindsColors.brown.uiColor
        return label
    }()
    
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.font?.withSize(14)
        label.textColor = SevenWindsColors.brown.uiColor
        label.textAlignment = .center
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(.plus, for: .normal)
        button.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(.minus, for: .normal)
        button.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupView(with item: MenuItemPresentable) {
        titleLabel.text = item.item.name
        priceLabel.text = "\(item.item.price ?? 0) " + MainPageLocalization.price.localized
        if let data  = item.imageData {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = .remove
        }
        countLabel.text = item.itemCount < 10 ? "\(item.itemCount)" : "9+"
    }
    
    func adoptBoundingWidth(_ width: CGFloat) {
        boundingWidth = width
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let height = (boundingWidth * (137.0/165.0) + 10 + 18 + 12 + 17 + 11)
        
        attributes.size = .init(width: boundingWidth, height: height)
        
        return attributes
    }
    
    private func setupUI() {
        addSubview(coverView)
        coverView.addSubview(titleLabel)
        coverView.addSubview(imageView)
        coverView.addSubview(priceLabel)
        coverView.addSubview(plusButton)
        coverView.addSubview(minusButton)
        coverView.addSubview(countLabel)
        
        coverView.layer.cornerRadius = 5
        coverView.layer.masksToBounds = true
        
        layer.cornerRadius = 5
        layer.masksToBounds = false
        
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        backgroundColor = .clear
        
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.right.left.equalToSuperview()
            make.width.equalTo(boundingWidth)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(11)
            make.right.equalToSuperview().inset(11)
            make.height.equalTo(18)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(11)
            make.left.equalToSuperview().inset(11)
            make.height.equalTo(17)
        }
        
        plusButton.snp.makeConstraints { make in
            make.left.equalTo(priceLabel.snp.right).offset(3)
            make.bottom.equalToSuperview().inset(7)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.height.width.equalTo(24)
        }
        
        countLabel.snp.makeConstraints { make in
            make.left.equalTo(plusButton.snp.right).offset(9)
            make.bottom.equalToSuperview().inset(7)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.width.equalTo(countLabelSize.width)
        }
        
        minusButton.snp.makeConstraints { make in
            make.left.equalTo(countLabel.snp.right).offset(9)
            make.bottom.equalToSuperview().inset(7)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.right.equalToSuperview().inset(5)
            make.height.width.equalTo(24)
        }
    }
}
