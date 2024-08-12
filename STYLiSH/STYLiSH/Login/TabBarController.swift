//
//  TabBarController.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/6.
//

import Foundation
import UIKit
import FacebookLogin

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let customTransitioningDelegate = CustomTransitioningDelegate()
    
    override func viewDidLoad() {
        view.backgroundColor = .clear
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let viewControllers = tabBarController.viewControllers,
           let index = viewControllers.firstIndex(of: viewController) {
            if index == 3 || index == 2{
                if !isLogIn() {
                    presentLogInVC()
                    return false
                }
            }
        }
        return true
    }
  
    func isLogIn() -> Bool{
        if let token = AccessToken.current,
           !token.isExpired {
            return true
        } else {
            return false
        }
    }
    
    @objc func presentLogInVC() {
        
        let loginVC = LoginPageViewController()
        loginVC.modalPresentationStyle = .custom
        loginVC.transitioningDelegate = customTransitioningDelegate
        present(loginVC, animated: true, completion: nil)
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
