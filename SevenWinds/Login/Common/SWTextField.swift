//
//  SWTextField.swift
//  SevenWinds
//
//  Created by Булат Мусин on 26.12.2023.
//

import UIKit
import SnapKit

class SWTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

class SWTextFieldView: UIView {
    
    let inputTextView: SWTextField = {
        let field = SWTextField()
        field.layer.borderColor = SevenWindsColors.brown.uiColor.cgColor
        field.layer.borderWidth = 2
        field.layer.cornerRadius = 23
        field.font = SevenWindsFonts.sfUiDisplay(weight: 300).font
        return field
    }()
    
    let textFieldTitle: UILabel = {
        let label = UILabel()
        label.font = SevenWindsFonts.sfUiDisplay(weight: 300).font
        label.textColor = SevenWindsColors.brown.uiColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        layouts()
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputTextView)
        addSubview(textFieldTitle)
    }
    
    func setupView(placeholder: String?, labelText: String) {
        textFieldTitle.text = labelText
        inputTextView.placeholder = placeholder
    }
    
    private func layouts() {
        inputTextView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(47)
        }
        
        textFieldTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(inputTextView.snp.top).offset(-7)
            make.height.equalTo(18)
        }
    }
}
