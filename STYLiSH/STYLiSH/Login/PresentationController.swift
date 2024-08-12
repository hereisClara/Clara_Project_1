//
//  PresentationController.swift
//  STYLiSH
//
//  Created by 小妍寶 on 2024/8/6.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        return view
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let height = containerView.bounds.height * 2 / 7
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        containerView.addSubview(dimmingView)
        dimmingView.frame = containerView.bounds
        dimmingView.alpha = 0
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.55
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
