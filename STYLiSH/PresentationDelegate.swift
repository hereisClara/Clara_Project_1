//
//  PresentationDelegate.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/6.
//

import UIKit

class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
