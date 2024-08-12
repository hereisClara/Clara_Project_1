//
//  CartViewController.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/1.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import CoreData
import IQKeyboardManagerSwift
import FacebookLogin


class CartViewController: UIViewController {
    
    var cartTableView = UITableView()
    let checkoutButton = UIButton()
    
    var models = [CartItem]()
    var modelsCount = Int()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var stockInt: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupTableView()
        setupFooterButton()
        getCartItems()
        updateTabBarBadge()
        setupNavigationitem()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("reloadCartData"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateTabBarBadge()
        cartTableView.reloadData()
    }
    
    func updateCartItemCountInUserDefaults(count: Int) {
        
        UserDefaults.standard.set(count, forKey: "cartItemCount")
    }
    
    @objc func reloadData() {
        
        getCartItems()
        updateTabBarBadge()
    }
    
    func getCartItems() {
        
        do {
            models = try context.fetch(CartItem.fetchRequest())
            modelsCount = models.count
        } catch {
            
        }
    }
    
    func updateTabBarBadge() {
        
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.items?[2].badgeValue = self.modelsCount > 0 ? "\(self.modelsCount)" : nil
            self.tabBarController?.tabBar.items?[2].badgeColor = .brown
        }
    }
    
    func setupNavigationitem() {
        
        let logOutButton = UIBarButtonItem(title: "登出", image: nil, target: self, action: #selector(logOutButtonTapped))
        logOutButton.tintColor = .darkGray
        
        self.navigationItem.rightBarButtonItem = logOutButton
    }
    
    @objc func logOutButtonTapped() {
        
        let manager = LoginManager()
        manager.logOut()
        deleteToken()
    }
    
    func deleteToken() {
        
        UserDefaults.standard.removeObject(forKey: "userToken")
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, CartItemTableViewCellDelegate, UITextFieldDelegate {
    
    func didTapAddButton(in cell: CartItemTableViewCell) {
        
        if let indexPath = cartTableView.indexPath(for: cell) {
            
            cell.cartItemAmountTextField.tag = indexPath.row
            cell.cartItemAmountTextField.delegate = self
            cell.cartItemAmountTextField.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
            
            if let textFieldText = cell.cartItemAmountTextField.text, let modelStockText = models[indexPath.row].stock {
                
                if let textFieldInt = Int(textFieldText), let modelStockInt = Int(modelStockText) {
                    
                    if modelStockInt > textFieldInt {
                        DispatchQueue.main.async {
                            cell.cartItemAmountTextField.text = "\(textFieldInt + 1)"
                            self.textFieldDidChange(textField: cell.cartItemAmountTextField)
                        }
                        if let cartNumberString = models[indexPath.row].cartNumber {
                            if let cartNumberInt = Int(cartNumberString) {
                                models[indexPath.row].cartNumber = String(cartNumberInt + 1)
                            }
                        }
                        do {
                            try context.save()
                            getCartItems()
                        } catch { }
                        
                    } else if modelStockInt <= textFieldInt {
                        DispatchQueue.main.async {
                            cell.cartItemAmountTextField.text = "\(textFieldInt)"
                            self.textFieldDidChange(textField: cell.cartItemAmountTextField)
                        }
                    }
                } else {
                    
                }
            } else {
                DispatchQueue.main.async {
                    cell.cartItemAmountTextField.text = "1"
                    self.textFieldDidChange(textField: cell.cartItemAmountTextField)
                }
            }
        } else {
            
        }
    }
    
    func didTapMinusButton(in cell: CartItemTableViewCell) {
        if let indexPath = cartTableView.indexPath(for: cell) {
            
            cell.cartItemAmountTextField.tag = indexPath.row
            cell.cartItemAmountTextField.delegate = self
            cell.cartItemAmountTextField.addTarget(self, action: #selector(textFieldDidChange(textField: )), for: .editingChanged)
            
            if let textFieldText = cell.cartItemAmountTextField.text {
                
                if let textFieldInt = Int(textFieldText) {
                    if textFieldInt > 1 {
                        DispatchQueue.main.async {
                            cell.cartItemAmountTextField.text = "\(textFieldInt - 1)"
                            self.textFieldDidChange(textField: cell.cartItemAmountTextField)
                        }
                        if let cartNumberString = models[indexPath.row].cartNumber {
                            if let cartNumberInt = Int(cartNumberString) {
                                models[indexPath.row].cartNumber = String(cartNumberInt - 1)
                            }
                        }
                        
                        do {
                            try context.save()
                            getCartItems()
                            
                        } catch { }
                        
                    } else {
                        DispatchQueue.main.async {
                            cell.cartItemAmountTextField.text = "\(textFieldInt)"
                            
                            self.textFieldDidChange(textField: cell.cartItemAmountTextField)
                        }
                    }
                    
                } else {
                    
                }
                
            } else {
                DispatchQueue.main.async {
                    cell.cartItemAmountTextField.text = "1"
                    self.textFieldDidChange(textField: cell.cartItemAmountTextField)
                }
            }
        } else {
            
        }
    }
    
    func didTapDeleteButton(in cell: CartItemTableViewCell) {
        
        if let indexPath = cartTableView.indexPath(for: cell) {
            context.delete(models[indexPath.row])
            models.remove(at: indexPath.row)
            cartTableView.deleteRows(at: [indexPath], with: .automatic)
            
            let newCartItemCount = models.reduce(0) { $0 + (Int($1.cartNumber ?? "") ?? 0) }
            updateCartItemCountInUserDefaults(count: newCartItemCount)
            updateTabBarBadge()
            do {
                try context.save()
                getCartItems()
            } catch { }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        let row = textField.tag
        let indexPath = IndexPath(row: row, section: 0)
        
        if let cell = cartTableView.cellForRow(at: indexPath) as? CartItemTableViewCell {
            
            if textField.text == "" {
                
                updateButtonStyle(button: cell.cartItemAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
                updateButtonStyle(button: cell.cartItemAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
                return
            }
            
            if let currentNumber = Int(textField.text ?? "") {
                
                if currentNumber == Int(models[indexPath.row].stock ?? "") {
                    updateButtonStyle(button: cell.cartItemAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
                    
                } else {
                    updateButtonStyle(button: cell.cartItemAmountPlusButton, borderColor: .darkGray, borderAlpha: 1, imageAlpha: 1)
                }
                
                if currentNumber <= 1 {
                    updateButtonStyle(button: cell.cartItemAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
                    
                } else {
                    updateButtonStyle(button: cell.cartItemAmountMinusButton, borderColor: .darkGray, borderAlpha: 1, imageAlpha: 1)
                }
                
            } else {
                updateButtonStyle(button: cell.cartItemAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
                updateButtonStyle(button: cell.cartItemAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
            }
        }
    }
    
    func updateButtonStyle(button: UIButton, borderColor: UIColor, borderAlpha: CGFloat, imageAlpha: CGFloat) {
        DispatchQueue.main.async {
            
            button.layer.borderColor = borderColor.withAlphaComponent(borderAlpha).cgColor
            button.layer.borderWidth = 1.0
            button.imageView?.alpha = imageAlpha
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if let newNumber = Int(updatedText), newNumber <= stockInt ?? 0, newNumber > 0 {
            return true
        } else if updatedText.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func setupTableView() {
        
        cartTableView.dataSource = self
        cartTableView.delegate = self
        cartTableView.frame = view.bounds
        cartTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.frame.height * 0.1, right: 0)
        cartTableView.backgroundColor = .clear
        cartTableView.separatorStyle = .none
        cartTableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: "cartItemTableViewCell")
        
        view.addSubview(cartTableView)
        
        cartTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        getCartItems()
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartItemTableViewCell", for: indexPath) as! CartItemTableViewCell
        let model = models[indexPath.row]
        
        stockInt = Int(model.stock ?? "")
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.cartItemTitle.text = model.title
        cell.cartItemImageView.kf.setImage(with: URL(string: model.image ?? ""))
        cell.cartItemPriceLabel.text = model.price
        cell.cartItemColor.backgroundColor = colorWithHexString(hex: model.color ?? "")
        cell.cartItemSizeLabel.text = model.size
        cell.cartItemAmountTextField.text = model.cartNumber
        
        cell.selectionStyle = .none
        
        if model.cartNumber == model.stock {
            updateButtonStyle(button: cell.cartItemAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
        } else if model.cartNumber == "1" {
            updateButtonStyle(button: cell.cartItemAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func setupFooterButton() {
        
        let footer = UIView()
        view.addSubview(footer)
        footer.backgroundColor = .white
        footer.snp.makeConstraints { make in
            make.width.equalTo(view)
            make.height.equalTo(view.frame.height * 0.1)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.centerX.equalTo(view)
        }
        
        let separatorView = UIView()
        view.addSubview(separatorView)
        separatorView.backgroundColor = .lightGray
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(footer)
            make.width.equalTo(footer)
            make.height.equalTo(1)
            make.centerX.equalTo(footer)
        }
        footer.addSubview(checkoutButton)
        
        checkoutButton.backgroundColor = colorWithHexString(hex: "3F3A3A")
        checkoutButton.setTitle("前往結帳", for: .normal)
        checkoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        checkoutButton.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "billSegue" {
            if let billVC = segue.destination as? BillViewController {
                billVC.billCartItem = models
            }
        }
    }
    
    @objc func didTapCheckoutButton() {
        
        self.performSegue(withIdentifier: "billSegue", sender: self)
    }
}

extension CartViewController {
    
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
