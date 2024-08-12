//
//  AddToCartPage.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/7/29.
//

import UIKit

class AddToCartTitleCell: UITableViewCell {
    
    var addToCartTitleLabel = UILabel()
    var addToCartPriceLabel = UILabel()
    var exitButton = UIButton()
    var separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "addToCartTitleCell")
        setupAddToCartTitleCell()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddToCartTitleCell() {
        
        self.addSubview(addToCartTitleLabel)
        self.addSubview(addToCartPriceLabel)
        self.contentView.addSubview(exitButton)
        self.addSubview(separatorView)
        
        addToCartTitleLabel.textColor = .darkGray
        addToCartTitleLabel.font = UIFont.systemFont(ofSize: 18)
        addToCartPriceLabel.textColor = .darkGray
        addToCartPriceLabel.font = UIFont.systemFont(ofSize: 16)
        separatorView.backgroundColor = colorWithHexString(hex: "#CCCCCC")
        exitButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
        
        addToCartTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToCartTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            addToCartPriceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartPriceLabel.topAnchor.constraint(equalTo: addToCartTitleLabel.bottomAnchor, constant: 15),
            exitButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            exitButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            exitButton.widthAnchor.constraint(equalToConstant: 24),
            exitButton.heightAnchor.constraint(equalToConstant: 24),
            separatorView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func updateUI(product: ProductProtocol) {
        
        addToCartTitleLabel.text = product.title
        addToCartPriceLabel.text = "$" + String(product.price)
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

protocol AddToCartColorCellDelegate {
    
    func didTapButtonInCell(colorCode: String?)
}

class AddToCartColorCell: UITableViewCell {
    
    var delegate: AddToCartColorCellDelegate?
    
    var addToCartColorChoiceLabel = UILabel()
    var addToCartColorStackView = UIStackView()
    var selectedButton: UIButton?
    
    var originWidthConstraint: [UIButton:NSLayoutConstraint] = [:]
    var originHeightConstraint: [UIButton:NSLayoutConstraint] = [:]
    
    var colorCode = String()
    var colorButtons: [UIButton] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "addToCartColorCell")
        setupAddToCartColorCell()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddToCartColorCell() {
        
        self.contentView.addSubview(addToCartColorChoiceLabel)
        self.contentView.addSubview(addToCartColorStackView)
        addToCartColorStackView.isUserInteractionEnabled = true
        
        addToCartColorChoiceLabel.textColor = .darkGray
        addToCartColorChoiceLabel.font = UIFont.systemFont(ofSize: 15)
        
        addToCartColorChoiceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartColorStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addToCartColorStackView.spacing = 12
        
        NSLayoutConstraint.activate([
            addToCartColorChoiceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartColorChoiceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            
            addToCartColorStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartColorStackView.topAnchor.constraint(equalTo: addToCartColorChoiceLabel.bottomAnchor, constant: 12)
        ])
    }
    
    func updateUI(product: ProductProtocol) {
        
        addToCartColorChoiceLabel.text = "選擇顏色"
        addToCartColorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for colorInfo in product.colors {
            
            let colorButton = UIButton()
            let containerView = UIView()
            
            originWidthConstraint[colorButton] = colorButton.widthAnchor.constraint(equalToConstant: 48)
            originHeightConstraint[colorButton] = colorButton.heightAnchor.constraint(equalToConstant: 48)
            
            colorButton.translatesAutoresizingMaskIntoConstraints = false
            originWidthConstraint[colorButton]?.isActive = true
            originHeightConstraint[colorButton]?.isActive = true
            colorButton.backgroundColor = colorWithHexString(hex: colorInfo.code)
            
            containerView.backgroundColor = .white
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
            containerView.addSubview(colorButton)
            addToCartColorStackView.addArrangedSubview(containerView)
            
            colorButton.isUserInteractionEnabled = true
            
            NSLayoutConstraint.activate([
                colorButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                colorButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
            colorButton.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            colorButtons.append(colorButton)
        }
    }
    
    var i = 0

    @objc func colorButtonTapped(_ sender: UIButton) {
        
        colorCode = hexStringFromColor(color: sender.backgroundColor ?? UIColor.clear) ?? ""
        if let oldSelected = selectedButton {
            
            i = i+1
            if oldSelected != sender {
                
                originHeightConstraint[sender]?.constant = 40
                originWidthConstraint[sender]?.constant = 40
                sender.superview?.layer.borderWidth = 2
                
                originWidthConstraint[oldSelected]?.constant = 48
                originHeightConstraint[oldSelected]?.constant = 48
                oldSelected.superview?.layer.borderWidth = 0
                
                self.layoutIfNeeded()
                
            } else {
                i = i+1

                sender.superview?.layer.borderColor = UIColor.darkGray.cgColor
                sender.superview?.layer.borderWidth = 2
                
                originWidthConstraint[sender]?.constant = 40
                originHeightConstraint[sender]?.constant = 40
                self.layoutIfNeeded()
            }
            
        } else {
            i = i+1

            sender.superview?.layer.borderColor = UIColor.darkGray.cgColor
            sender.superview?.layer.borderWidth = 2
            
            originWidthConstraint[sender]?.constant = 40
            originHeightConstraint[sender]?.constant = 40
            self.layoutIfNeeded()
        }
        selectedButton = sender
        delegate?.didTapButtonInCell(colorCode: colorCode)
    }
    
    func resetColorSelection() {
        
        for button in colorButtons {
            originWidthConstraint[button]?.constant = 48
            originHeightConstraint[button]?.constant = 48
            button.superview?.layer.borderWidth = 0
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
    
    func hexStringFromColor(color: UIColor) -> String? {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
        return String(format: "#%06x", rgb)
    }
}

protocol AddToCartSizeCellDelegate {
    
    func didTapSizeButton(_ button: UIButton?, size: String?, colorName: String?)
}

class AddToCartSizeCell: UITableViewCell {
    
    var delegate: AddToCartSizeCellDelegate?
    
    var addToCartSizeChoiceLabel = UILabel()
    var addToCartSizeStackView = UIStackView()
    var addToCartSizeButton = UIButton()
    var selectedButton: UIButton?
    let containerView = UIView()
    
    var originWidthConstraint: [UIButton:NSLayoutConstraint] = [:]
    var originHeightConstraint: [UIButton:NSLayoutConstraint] = [:]
    
    var sizeButtons: [UIButton] = []
    
    var size = String()
    var colorName = String()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "addToCartSizeCell")
        setupAddToCartSizeCell()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddToCartSizeCell() {
        
        self.contentView.addSubview(addToCartSizeChoiceLabel)
        self.contentView.addSubview(addToCartSizeStackView)
        self.contentView.addSubview(addToCartSizeButton)
        
        addToCartSizeChoiceLabel.textColor = .darkGray
        addToCartSizeChoiceLabel.font = UIFont.systemFont(ofSize: 15)
        
        addToCartSizeChoiceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartSizeStackView.translatesAutoresizingMaskIntoConstraints = false
        addToCartSizeButton.translatesAutoresizingMaskIntoConstraints = false
        
        addToCartSizeStackView.spacing = 10
        
        NSLayoutConstraint.activate([
            addToCartSizeChoiceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartSizeChoiceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            
            addToCartSizeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartSizeStackView.topAnchor.constraint(equalTo: addToCartSizeChoiceLabel.bottomAnchor, constant: 12)
        ])
        
        addToCartSizeChoiceLabel.text = "選擇尺寸"
    }
    
    func updateUI(product: ProductProtocol) {
        
        sizeButtons = []
        
        for (index, sizeInfo) in product.sizes.enumerated() {
            
            let sizeButton = UIButton()
            let containerView = UIView()
            
            originWidthConstraint[sizeButton] = sizeButton.widthAnchor.constraint(equalToConstant: 48)
            originHeightConstraint[sizeButton] = sizeButton.heightAnchor.constraint(equalToConstant: 48)
            
            sizeButton.setTitle(sizeInfo, for: .normal)
            sizeButton.translatesAutoresizingMaskIntoConstraints = false
            sizeButton.isUserInteractionEnabled = false
            sizeButton.tag = index
            
            originWidthConstraint[sizeButton]?.isActive = true
            originHeightConstraint[sizeButton]?.isActive = true
            
            sizeButton.backgroundColor = colorWithHexString(hex: "#F0F0F0")
            sizeButton.setTitleColor(UIColor.lightGray, for: .normal)
            sizeButton.layer.borderColor = UIColor.darkGray.cgColor
            
            containerView.backgroundColor = .white
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            
            containerView.addSubview(sizeButton)
            addToCartSizeStackView.addArrangedSubview(containerView)
            
            NSLayoutConstraint.activate([
                sizeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                sizeButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
            sizeButton.addTarget(self, action: #selector(sizeButtonTapped(_:)), for: .touchUpInside)
            sizeButtons.append(sizeButton)
        }
    }
    
    func updateButtonUI( fitColorCode: String, product: ProductProtocol ){
        
        for button in sizeButtons {
            
            containerView.removeFromSuperview()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.superview?.layer.borderWidth = 0
            button.isUserInteractionEnabled = false
            button.setTitleColor(.lightGray, for: .normal)
        }
        
        for button in sizeButtons {
            
            for i in 0 ..< product.variants.count {
                
                if fitColorCode == product.variants[i].colorCode {
                    
                    if product.variants[i].stock != 0 {
                        
                        if product.variants[i].size == button.titleLabel?.text {
                            
                            button.isUserInteractionEnabled = true
                            button.setTitleColor(.darkGray, for: .normal)
                        }
                    }
                }
            }
        }
        for i in 0 ..< product.colors.count {
            
            if fitColorCode == product.colors[i].code {
                
                colorName = product.colors[i].name
            }
        }
    }

    @objc func sizeButtonTapped(_ sender: UIButton ) {
        
        if let oldSelected = selectedButton {
            
            if oldSelected != sender {
                originWidthConstraint[sender]?.constant = 40
                originHeightConstraint[sender]?.constant = 40
                sender.superview?.layer.borderWidth = 2
                
                originWidthConstraint[oldSelected]?.constant = 48
                originHeightConstraint[oldSelected]?.constant = 48
                oldSelected.superview?.layer.borderWidth = 0
                
                self.layoutIfNeeded()
                
            } else {
                sender.superview?.layer.borderColor = UIColor.darkGray.cgColor
                sender.superview?.layer.borderWidth = 2
                originWidthConstraint[sender]?.constant = 40
                originHeightConstraint[sender]?.constant = 40
                self.layoutIfNeeded()
            }
            
        } else {
            sender.superview?.layer.borderColor = UIColor.darkGray.cgColor
            sender.superview?.layer.borderWidth = 2
            originWidthConstraint[sender]?.constant = 40
            originHeightConstraint[sender]?.constant = 40
            self.layoutIfNeeded()
        }
        
        size = sender.titleLabel?.text ?? ""
        selectedButton = sender
        delegate?.didTapSizeButton(sender, size: size, colorName: colorName)
    }
    
    func resetSizeSelection() {
        
        for button in sizeButtons {
            
            originWidthConstraint[button]?.constant = 48
            originHeightConstraint[button]?.constant = 48
            button.superview?.layer.borderWidth = 0
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

protocol AddToCartAmountCellDelegate {
    
    func didUpdateTextfieldValue(_ text: String)
}

class AddToCartAmountCell: UITableViewCell, UITextFieldDelegate {
    
    var delegate: AddToCartAmountCellDelegate?
    
    var addToCartAmountChoiceLabel = UILabel()
    var addToCartStockLabel = UILabel()
    var addToCartAmountStackView = UIStackView()
    var addToCartAmountPlusButton = UIButton()
    var addToCartAmountMinusButton = UIButton()
    var addToCartAmountTextField = UITextField()
    var separatorView = UIView()
    
    var stockInt = Int()
    var textfieldText = String()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: "addToCartSizeCell")
        setupAddToCartAmountCell()
        addToCartAmountTextField.delegate = self
        addToCartAmountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAddToCartAmountCell() {
        
        self.addSubview(addToCartAmountChoiceLabel)
        self.contentView.addSubview(addToCartAmountStackView)
        self.contentView.addSubview(addToCartAmountPlusButton)
        self.contentView.addSubview(addToCartAmountMinusButton)
        self.contentView.addSubview(addToCartAmountTextField)
        self.addSubview(separatorView)
        self.addSubview(addToCartStockLabel)
        
        addToCartAmountChoiceLabel.textColor = .darkGray
        addToCartAmountChoiceLabel.font = UIFont.systemFont(ofSize: 15)
        addToCartStockLabel.textColor = .darkGray
        addToCartStockLabel.font = UIFont.systemFont(ofSize: 15)
        
        addToCartAmountChoiceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartAmountStackView.translatesAutoresizingMaskIntoConstraints = false
        addToCartAmountPlusButton.translatesAutoresizingMaskIntoConstraints = false
        addToCartAmountMinusButton.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        addToCartStockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addToCartAmountPlusButton.isUserInteractionEnabled = false
        addToCartAmountMinusButton.isUserInteractionEnabled = false
        addToCartAmountTextField.isUserInteractionEnabled = false
        
        separatorView.backgroundColor = colorWithHexString(hex: "#CCCCCC")
        
        NSLayoutConstraint.activate([
            addToCartAmountChoiceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartAmountChoiceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            
            addToCartAmountStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            addToCartAmountStackView.topAnchor.constraint(equalTo: addToCartAmountChoiceLabel.bottomAnchor, constant: 12),
            addToCartAmountStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            separatorView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            addToCartAmountPlusButton.widthAnchor.constraint(equalToConstant: 48),
            addToCartAmountPlusButton.heightAnchor.constraint(equalToConstant: 48),
            addToCartAmountMinusButton.widthAnchor.constraint(equalToConstant: 48),
            addToCartAmountMinusButton.heightAnchor.constraint(equalToConstant: 48),
            
            addToCartStockLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            addToCartStockLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15)
        ])
        
        addToCartAmountChoiceLabel.text = "選擇數量"
        addToCartStockLabel.isHidden = true
        addToCartAmountPlusButton.setImage(UIImage(named: "Icons_24px_Add01"), for: .normal)
        addToCartAmountMinusButton.setImage(UIImage(named: "Icons_24px_Subtract01"), for: .normal)
        
        addToCartAmountStackView.addArrangedSubview(addToCartAmountMinusButton)
        addToCartAmountStackView.addArrangedSubview(addToCartAmountTextField)
        addToCartAmountStackView.addArrangedSubview(addToCartAmountPlusButton)
        
        updateButtonStyle(button: addToCartAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
        updateButtonStyle(button: addToCartAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
        updateTextfieldStyle(textfield: addToCartAmountTextField, borderColor: .darkGray, alpha: 0.5)
        
        addToCartAmountTextField.text = "1"
        addToCartAmountTextField.textAlignment = .center
        addToCartAmountTextField.keyboardType = .numberPad
        
        addToCartAmountPlusButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addToCartAmountMinusButton.addTarget(self, action:#selector(minusButtonTapped) , for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        
        if let currentText = addToCartAmountTextField.text, let currentNumber = Int(currentText) {
            
            if currentNumber < stockInt {
                addToCartAmountTextField.text = "\(currentNumber + 1)"
            } else if currentNumber >= stockInt {
                addToCartAmountTextField.text = "\(currentNumber)"
            }
            
        } else {
            addToCartAmountTextField.text = "1"
        }
        textFieldDidChange(addToCartAmountTextField)
    }
    
    @objc func minusButtonTapped() {
        
        if let currentText = addToCartAmountTextField.text, let currentNumber = Int(currentText) {
            if currentNumber > 1 {
                addToCartAmountTextField.text = "\(currentNumber - 1)"
                
            } else if currentNumber <= 1 {
                addToCartAmountTextField.text = "\(currentNumber)"
            }
        } else {
            addToCartAmountTextField.text = "1"
        }
        textFieldDidChange(addToCartAmountTextField)
    }
    
    func updateStockLabel(fitColorCode:String, product: ProductProtocol, size: String){
        
        for i in 0 ..< product.variants.count {
            
            if fitColorCode == product.variants[i].colorCode {
                
                if product.variants[i].stock != 0 {
                    
                    if size == product.variants[i].size {
                        
                        addToCartStockLabel.isHidden = false
                        addToCartStockLabel.text = "庫存：\(product.variants[i].stock)"
                        stockInt = product.variants[i].stock
                    }
                }
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
    
    func updateTextfieldStyle(textfield: UITextField, borderColor: UIColor, alpha: CGFloat) {
        
        textfield.layer.borderColor = borderColor.withAlphaComponent(alpha).cgColor
        textfield.layer.borderWidth = 1.0
    }
    
    func getStockData(with stock: Int) {
        
        stockInt = stock
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        updateButtonStyles(for: updatedText)
        
        if let newNumber = Int(updatedText), newNumber <= stockInt, newNumber > 0 {
            return true
        } else if updatedText.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        updateButtonStyles(for: textField.text ?? "")
        delegate?.didUpdateTextfieldValue(textField.text ?? "")
    }
    
    func updateButtonStyles(for text: String) {
        
        textfieldText = text
        
        if text.isEmpty {
            updateButtonStyle(button: addToCartAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
            updateButtonStyle(button: addToCartAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
            return
        }
        
        if let currentNumber = Int(text) {
            
            if currentNumber == stockInt {
                updateButtonStyle(button: addToCartAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
            } else {
                updateButtonStyle(button: addToCartAmountPlusButton, borderColor: .darkGray, borderAlpha: 1, imageAlpha: 1)
            }
            
            if currentNumber <= 1 {
                updateButtonStyle(button: addToCartAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
            } else {
                updateButtonStyle(button: addToCartAmountMinusButton, borderColor: .darkGray, borderAlpha: 1, imageAlpha: 1)
            }
        } else {
            updateButtonStyle(button: addToCartAmountPlusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
            updateButtonStyle(button: addToCartAmountMinusButton, borderColor: .darkGray, borderAlpha: 0.5, imageAlpha: 0.5)
        }
    }
}

