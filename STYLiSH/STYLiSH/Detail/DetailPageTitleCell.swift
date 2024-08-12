//
//  DetailPageTitleCell.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/26.
//

import UIKit

class DetailPageTitleCell: UITableViewCell{
    
    let titleLabel = UILabel()
    let idLabel = UILabel()
    let priceLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "titleCell")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        idLabel.textColor = .lightGray
        idLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = .darkGray
        priceLabel.font = UIFont.systemFont(ofSize: 18)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(idLabel)
        self.contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -5),
            
            idLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            idLabel.topAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 5),
            
            priceLabel.bottomAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -10),
            priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func updateUI(product: ProductProtocol) {
        
        self.titleLabel.text = product.title
        self.idLabel.text = String(product.id)
        self.priceLabel.text = "$" + String(product.price)
    }
}

