//
//  CheckOutPage.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/9.
//

import Foundation
import UIKit
import SnapKit

class CheckOutPageViewController: UIViewController {
    
    var titleLabel = UILabel()
    var descriptionLabel = UILabel()
    var checkOutImageView = UIImageView()
    var checkOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCheckOutPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setupCheckOutPage() {
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(checkOutImageView)
        view.addSubview(checkOutButton)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(28)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(35)
            make.centerX.equalTo(titleLabel)
            make.height.equalTo(44)
        }
        
        checkOutImageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel).offset(-50)
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.centerX.equalTo(titleLabel)
        }
        
        checkOutButton.snp.makeConstraints { make in
            make.width.equalTo(view).multipliedBy(0.87)
            make.centerX.equalTo(view)
            make.height.equalTo(48)
            make.bottom.equalTo(view).offset(-35)
        }
        
        titleLabel.text = "結帳成功"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        descriptionLabel.text = "我們收到您的訂單了！將以最快的速度為您安排出貨。"
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        
        checkOutButton.setTitle("再去逛逛", for: .normal)
        checkOutButton.backgroundColor = colorWithHexString(hex: "#3F3A3A")
        checkOutButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        checkOutImageView.image = UIImage(named: "Icons_80px_Success02")
    }
    
    @objc func buttonTapped() {
        if let navigationController = self.navigationController {
            let currentIndex = navigationController.viewControllers.count - 1
            
            if currentIndex >= 2 {
                let viewControllers = navigationController.viewControllers
                let targetVC = viewControllers[viewControllers.count - 3]
                
                navigationController.popToViewController(targetVC, animated: true)
                targetVC.tabBarController?.tabBar.isHidden = false
            }
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
