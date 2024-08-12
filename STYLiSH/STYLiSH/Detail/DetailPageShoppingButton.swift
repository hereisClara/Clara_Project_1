//
//  DetailPageShoppingButton.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/27.
//

import UIKit

class DetailPageShoppingButton: UIView {
    
    var detailVC: DetailPageViewController?
    
    let containerView = UIView()
    let shoppingButton = UIButton()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupShoppingButton()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupShoppingButton() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        
        shoppingButton.translatesAutoresizingMaskIntoConstraints = false
        shoppingButton.isUserInteractionEnabled = true
        shoppingButton.setTitle("加入購物車", for: .normal)
        shoppingButton.backgroundColor = colorWithHexString(hex: "3F3A3A")
        shoppingButton.setTitleColor(.white, for: .normal)
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        addSubview(shoppingButton)
        
        NSLayoutConstraint.activate([
            shoppingButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            shoppingButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20),
            shoppingButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.7),
            shoppingButton.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.4)
        ])
        shoppingButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        
            shoppingButton.backgroundColor = colorWithHexString(hex: "#999999")
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
