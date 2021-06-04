//
//  PresentationController.swift
//  NFTrack-Firebase4
//
//  Created by J C on 2021-05-12.
//

import UIKit

class PresentationController: UIPresentationController {
    var height: CGFloat!
    let dimmingView: UIView = {
        let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        return dimmingView
    }()
    var constraints = [NSLayoutConstraint]()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: bounds.size.width * 0.8, height: height)
        let origin = CGPoint(x: bounds.midX - size.width / 2, y: bounds.midY - size.height / 2)
        return CGRect(origin: origin, size: size)
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, height: CGFloat) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        self.height = height
        
//        presentedView?.autoresizingMask = [
//            .flexibleTopMargin,
//            .flexibleBottomMargin,
//            .flexibleLeftMargin,
//            .flexibleRightMargin
//        ]
//
//        presentedView?.translatesAutoresizingMaskIntoConstraints = true
        
        addKeyboardObserver()
        
        guard let presentedView = presentedView, let containerView = containerView else { return }
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(contentsOf: [
            presentedView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            presentedView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        NSLayoutConstraint.activate(constraints)
    }
    
    deinit {
        removeKeyboardObserver()
    }
}

extension PresentationController {
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        let superview = presentingViewController.view!
        superview.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            dimmingView.topAnchor.constraint(equalTo: superview.topAnchor)
        ])
        
        dimmingView.alpha = 0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.9
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
}

extension PresentationController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotifications(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotifications(notification: NSNotification) {
        NSLayoutConstraint.deactivate(constraints)
        guard let presentedView = presentedView, let containerView = containerView else { return }
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        let newConstraints = [
            presentedView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            presentedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 100),
            presentedView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
            presentedView.heightAnchor.constraint(equalToConstant: height)
        ]
        NSLayoutConstraint.activate(newConstraints)
        
        UIView.animate(withDuration: 0.5) {
            containerView.layoutIfNeeded()
        }
    }
}
