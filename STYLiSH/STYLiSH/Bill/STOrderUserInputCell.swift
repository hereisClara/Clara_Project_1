//
//  STUserInputCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/25.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

protocol STOrderUserInputCellDelegate: AnyObject {
    
    func didChangeUserData(
        _ cell: STOrderUserInputCell,
        username: String,
        email: String,
        phoneNumber: String,
        address: String,
        shipTime: String
    )
}

class STOrderUserInputCell: UITableViewCell {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var shipTimeSelector: UISegmentedControl!
    
    weak var delegate: STOrderUserInputCellDelegate?
    var shipTime = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameTextField.isEnabled = true
        emailTextField.isEnabled = true
        phoneTextField.isEnabled = true
        addressTextField.isEnabled = true
        
        phoneTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingChanged)
        shipTimeSelector.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .valueChanged)
        
        phoneTextField.keyboardType = .numberPad
    }
}

extension STOrderUserInputCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if shipTimeSelector.selectedSegmentIndex == 0 {
            shipTime = "morning"
        } else if shipTimeSelector.selectedSegmentIndex == 1 {
            shipTime = "afternoon"
        } else {
            shipTime = "anytime"
        }
        
        guard
            let name = nameTextField.text,
            let email = emailTextField.text,
            let phoneNumber = phoneTextField.text,
            let address = addressTextField.text else
        {
            return
        }
        
        delegate?.didChangeUserData(
            self,
            username: name,
            email: email,
            phoneNumber: phoneNumber,
            address: address,
            shipTime: shipTime
        )
    }
}

class STOrderUserInputTextField: UITextField, UITextFieldDelegate {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addUnderLine()
    }
    
    private func addUnderLine() {
        
        let underline = UIView()
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            
            leadingAnchor.constraint(equalTo: underline.leadingAnchor),
            trailingAnchor.constraint(equalTo: underline.trailingAnchor),
            bottomAnchor.constraint(equalTo: underline.bottomAnchor),
            underline.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        
        underline.backgroundColor = UIColor.hexStringToUIColor(hex: "cccccc")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterSet = CharacterSet.decimalDigits
        let characterSetInText = CharacterSet(charactersIn: string)
        
        if !characterSet.isSuperset(of: characterSetInText) {
            return false
        }
        
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        return currentText.count <= 10
    }
}
