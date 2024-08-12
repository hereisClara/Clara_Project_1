//
//  DetailPageInformationCell.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/26.
//

import UIKit

class DetailPageInformationCell: UITableViewCell {
    
    let typeLabel = UILabel()
    let explanationLabel = UILabel()
    let separatorLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "informationCell")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(explanationLabel)
        self.contentView.addSubview(separatorLabel)
        
        typeLabel.textColor = .darkGray
        typeLabel.font = UIFont.systemFont(ofSize: 16)
        explanationLabel.textColor = .darkGray
        explanationLabel.font = UIFont.systemFont(ofSize: 16)
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            typeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: 40),
            separatorLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            separatorLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 10),
            explanationLabel.leadingAnchor.constraint(equalTo: separatorLabel.trailingAnchor, constant: 20),
            explanationLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        separatorLabel.text = "|"
        separatorLabel.textColor = .lightGray
    }
    
    func updateUI(product: ProductProtocol, indexPath: Int) {
        
        var stock = 0
        let innerIndexForArray = indexPath - 3
        let size: String
        let startIndex = product.sizes.startIndex
        let endIndex = product.sizes.endIndex - 1
        
        for i in 0 ..< product.variants.count {
            stock += product.variants[i].stock
        }
        
        if product.sizes.count != 1 {
            size = "\(product.sizes[startIndex]) - \(product.sizes[endIndex])"
        } else {
            size = product.sizes[0]
        }
        
        let informationArray = [size, String(stock), product.texture, product.wash, product.place, product.note] as [Any]
        let typeArray = ["尺寸", "庫存", "材質", "洗滌", "產地", "備註"]
        
        self.typeLabel.text = typeArray[innerIndexForArray]
        self.explanationLabel.text = informationArray[innerIndexForArray] as? String
    }
    
}
