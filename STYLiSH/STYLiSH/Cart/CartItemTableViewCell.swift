//
//  CartItemTableViewCell.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/2.
//

import UIKit
import Foundation
import SnapKit

protocol CartItemTableViewCellDelegate: AnyObject {
    
    func didTapDeleteButton(in cell: CartItemTableViewCell)
    func didTapAddButton(in cell: CartItemTableViewCell)
    func didTapMinusButton(in cell: CartItemTableViewCell)
}

class CartItemTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: CartItemTableViewCellDelegate?
    
    let cartItemImageView = UIImageView()
    let cartItemTitle = UILabel()
    let cartItemColor = UIView()
    let separatorLabel = UILabel()
    let cartItemSizeLabel = UILabel()
    let cartitemAmountStackView = UIStackView()
    let cartItemDeleteButton = UIButton()
    let cartItemPriceLabel = UILabel()
    
    let cartItemAmountMinusButton = UIButton()
    let cartItemAmountPlusButton = UIButton()
    let cartItemAmountTextField = UITextField()
    
    var stockInt = Int()
    
    var indexPath: IndexPath?
    
    func getStockInt(stock: Int) {
        self.stockInt = stock
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "cartItemTableViewCell")
        setupCartItemTableViewCell()
        cartItemAmountTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCartItemTableViewCell() {
        
        self.contentView.addSubview(cartItemImageView)
        self.contentView.addSubview(cartItemTitle)
        self.contentView.addSubview(cartItemColor)
        self.contentView.addSubview(separatorLabel)
        self.contentView.addSubview(cartItemSizeLabel)
        self.contentView.addSubview(cartitemAmountStackView)
        self.contentView.addSubview(cartItemDeleteButton)
        self.contentView.addSubview(cartItemPriceLabel)
        
        cartitemAmountStackView.addArrangedSubview(cartItemAmountMinusButton)
        cartitemAmountStackView.addArrangedSubview(cartItemAmountTextField)
        cartitemAmountStackView.addArrangedSubview(cartItemAmountPlusButton)
        
        cartitemAmountStackView.spacing = 0
        cartitemAmountStackView.axis = .horizontal
        
        cartItemImageView.translatesAutoresizingMaskIntoConstraints = false
        cartItemTitle.translatesAutoresizingMaskIntoConstraints = false
        cartItemColor.translatesAutoresizingMaskIntoConstraints = false
        cartItemSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        cartItemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        cartItemDeleteButton.translatesAutoresizingMaskIntoConstraints = false
        cartitemAmountStackView.translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cartItemImageView.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.width.equalTo(82)
            make.leadingMargin.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        cartItemTitle.snp.makeConstraints { make in
            make.leading.equalTo(cartItemImageView.snp.trailing).offset(24)
            make.top.equalToSuperview().offset(20)
        }
        
        cartItemColor.snp.makeConstraints { make in
            make.top.equalTo(cartItemTitle.snp.bottom).offset(10)
            make.leading.equalTo(cartItemTitle)
            make.width.equalTo(22)
            make.height.equalTo(22)
        }
        
        separatorLabel.snp.makeConstraints { make in
            make.leading.equalTo(cartItemColor.snp.trailing).offset(12)
            make.centerY.equalTo(cartItemColor)
        }
        
        cartItemSizeLabel.snp.makeConstraints { make in
            make.leading.equalTo(separatorLabel.snp.trailing).offset(12)
            make.centerY.equalTo(cartItemColor)
        }
        
        cartitemAmountStackView.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(32)
            make.top.equalTo(cartItemColor.snp.bottom).offset(15)
            make.leading.equalTo(cartItemTitle)
        }
        
        cartItemAmountPlusButton.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        cartItemAmountMinusButton.snp.makeConstraints { make in
            make.width.equalTo(32)
        }
        
        cartItemDeleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(21)
            make.width.equalTo(40)
        }
        
        cartItemPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(cartItemDeleteButton.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        cartItemImageView.image = UIImage(named: "Image_Placeholder")
        cartItemImageView.contentMode = .scaleToFill
        
        cartItemAmountMinusButton.setImage(UIImage(named: "Icons_24px_Subtract01"), for: .normal)
        cartItemAmountPlusButton.setImage(UIImage(named: "Icons_24px_Add01"), for: .normal)
        cartItemAmountTextField.text = "1"
        cartItemAmountTextField.textAlignment = .center
        cartItemAmountTextField.layer.borderColor = UIColor.gray.cgColor
        cartItemAmountTextField.layer.borderWidth = 1
        cartItemAmountPlusButton.layer.borderColor = UIColor.gray.cgColor
        cartItemAmountPlusButton.layer.borderWidth = 1
        cartItemAmountMinusButton.layer.borderColor = UIColor.gray.withAlphaComponent(1).cgColor
        cartItemAmountMinusButton.imageView?.alpha = 1
        cartItemAmountMinusButton.layer.borderWidth = 1
        
        cartItemColor.backgroundColor = .cyan
        cartItemTitle.text = "產品名稱"
        cartItemSizeLabel.text = "S"
        separatorLabel.text = "|"
        cartItemDeleteButton.setTitle("移除", for: .normal)
        cartItemDeleteButton.setTitleColor(.lightGray, for: .normal)
        cartItemPriceLabel.text = "NT$1000"
        
        cartItemDeleteButton.isUserInteractionEnabled = true
        
        cartItemAmountTextField.keyboardType = .numberPad
        
        cartItemAmountPlusButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        cartItemAmountMinusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        cartItemDeleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        delegate?.didTapAddButton(in: self)
    }
    
    @objc func minusButtonTapped() {
        delegate?.didTapMinusButton(in: self)
    }
    
    @objc func deleteButtonTapped() {
        delegate?.didTapDeleteButton(in: self)
    }
}
