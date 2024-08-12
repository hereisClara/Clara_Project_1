//
//  LoginPageViewController.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/6.
//

import Foundation
import UIKit
import FacebookLogin
import SnapKit
import Alamofire

class LoginPageViewController: UIViewController{
    
    var userName = String()
    var userPhoto = String()
    var userEmail = String()
    
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let separatorView = UIView()
    let logInButton = UIButton(type: .custom)
    let exitButton = UIButton()
    
    var tokenString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoginPage()
        
        getFacebookProfile()
    }
    
    func setupLoginPage(){
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(separatorView)
        view.addSubview(logInButton)
        view.addSubview(exitButton)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(25)
            make.top.equalTo(view).offset(35)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).offset(25)
            make.top.equalTo(titleLabel).offset(45)
        }
        
        separatorView.snp.makeConstraints { make in
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(1)
            make.top.equalTo(descriptionLabel).offset(45)
            make.centerX.equalTo(view)
        }
        
        logInButton.snp.makeConstraints { make in
            make.width.equalTo(view).multipliedBy(0.85)
            make.height.equalTo(view).multipliedBy(0.19)
            make.centerX.equalTo(view)
            make.top.equalTo(separatorView).offset(25)
        }
        
        exitButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.trailing.equalTo(view).offset(-28)
            make.top.equalTo(30)
        }
        
        titleLabel.text = "請先登入會員"
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .black
        descriptionLabel.text = "登入會員後即可完成結帳"
        descriptionLabel.font = UIFont.systemFont(ofSize: 18)
        separatorView.backgroundColor = .lightGray
        descriptionLabel.textColor = .black
        logInButton.backgroundColor = .systemBlue
        logInButton.setTitle("Facebook登入", for: .normal)
        logInButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        exitButton.setImage(UIImage(named: "Icons_24px_Close"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
    }

    func getFacebookProfile(){
        Profile.enableUpdatesOnAccessTokenChange(true)
        NotificationCenter.default.addObserver(
            forName: .ProfileDidChange,
            object: nil,
            queue: .main
        ) { notification in
            if Profile.current != nil {
                Profile.loadCurrentProfile { profile, error in
                    if profile != nil {
                        self.userName = profile?.name ?? ""
                        if let imageURL = profile?.imageURL(forMode: .square, size: CGSize(width: 300, height: 300)) {
                            self.userPhoto = imageURL.absoluteString
                        } else {
                            self.userPhoto = ""
                        }
                    }
                }
            }
            
            let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
            request.start { response, result, error in
                if let result = result as? [String: Any], let email = result["email"] as? String {
                    self.userEmail = email
                  
                    FacebookUserData.shared.sendSignInDataToServer(token: self.tokenString) { result in
                        switch result {
                        case .success:
                            break
                        case .failure:
                            break
                        }
                    }
                    
                }
            }
        }
    }
    
    @objc func exitButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func loginButtonClicked() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if error != nil {
                
            } else if let result = result, result.isCancelled {
                
            } else if let result = result, let tokenString = result.token?.tokenString {
                
                self.exitButtonTapped()
                FacebookUserData.shared.sendSignInDataToServer(token: tokenString) { result in
                    switch result {
                    case .success:
                        break
                    case .failure:
                        break
                    }
                }
            }
        }
    }
}
