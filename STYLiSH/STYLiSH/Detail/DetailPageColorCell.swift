//
//  DetailPageColorCell.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/26.
//

import UIKit

class DetailPageColorCell: UITableViewCell {
    
    let typeLabel = UILabel()
    let colorView = UIView()
    let colorStackView = UIStackView()
    let separatorLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "colorCell")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.contentView.addSubview(typeLabel)
        self.contentView.addSubview(colorView)
        self.contentView.addSubview(colorStackView)
        self.contentView.addSubview(separatorLabel)
        
        typeLabel.textColor = .darkGray
        typeLabel.font = UIFont.systemFont(ofSize: 16)
        
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorStackView.translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        colorStackView.axis = .horizontal
        colorStackView.spacing = 10
        colorStackView.alignment = .leading
        colorStackView.distribution = .equalSpacing
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            typeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: 40),
            separatorLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            separatorLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 10),
            colorStackView.leadingAnchor.constraint(equalTo: separatorLabel.trailingAnchor, constant: 20),
            colorStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
        
        separatorLabel.text = "|"
        separatorLabel.textColor = .lightGray
    }
    
    func updateUI(product: ProductProtocol) {
        
        self.typeLabel.text = "顏色"
        
        colorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for colorInfo in product.colors {
            let colorView = UIView()
            colorView.translatesAutoresizingMaskIntoConstraints = false
            colorView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            colorView.backgroundColor = colorWithHexString(hex: colorInfo.code)
            colorStackView.addArrangedSubview(colorView)
            colorView.layer.borderWidth = 1.0
            colorView.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    func colorWithHexString(hex: String) -> UIColor {
        
        var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        guard hexString.count == 6 else {
            return UIColor.black
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
