//
//  CoffeeshopTableViewCell.swift
//  SevenWinds
//
//  Created by Булат Мусин on 29.12.2023.
//

import UIKit

class CoffeeshopTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay.bold?.withSize(18)
        label.textColor = SevenWindsColors.brown.uiColor
        label.numberOfLines = 0
        return label
    }()
    
    private let distanceLabel: UILabel = {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func setupView(with location: Location, distance: Int? = nil) {
        titleLabel.text = location.name
        if let distance = distance {
            distanceLabel.text = "\(distance) " + MainPageLocalization.distance.localized
        }
    }
    
    private func setupUI() {
        addSubview(brownView)
        addSubview(titleLabel)
        addSubview(distanceLabel)
        backgroundColor = .clear
        
        brownView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3)
            make.bottom.left.right.equalToSuperview().inset(3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(21)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(9)
            make.right.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(21)
        }
    }
}
