//
//  TransitionDelegate.swift
//  Seed Share
//
//  Created by Tingbo Chen on 6/23/15.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = SlideInPresentationAnimator()
//        let presentationAnimator = TransitionPresentationAnimator()
        return presentationAnimator
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissalAnimator = SlideInDismissalAnimator()
//        let dismissalAnimator = TransitionDismissalAnimator()
        return dismissalAnimator
    }
}
