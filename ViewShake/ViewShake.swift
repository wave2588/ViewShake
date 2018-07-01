//
//  ViewShake.swift
//  ViewShake
//
//  Created by wave on 2018/7/1.
//  Copyright © 2018 wave. All rights reserved.
//

import UIKit

class ViewShake: NSObject {
    
    fileprivate let kViewShakerDefaultDuration : TimeInterval = 0.5
    fileprivate let kViewShakerAnimationKey : String = "kViewShakerAnimationKey"
    
    fileprivate var views : [UIView]?
    fileprivate var completedAnimations : NSInteger = 0
    
    fileprivate var completionBlock : (()->Void)?
    
    static let shared = ViewShake();
    
    func shakeViews(views: [UIView]) {
        shakeWithDuration(duration: kViewShakerDefaultDuration, views: views, completionHandler: nil)
    }
    
    func shakeWithDuration(duration: TimeInterval, views: [UIView], completionHandler:(()->())?) {
        
        self.views = views
        self.completionBlock = completionHandler
        self.views?.forEach({ (view) in
            self.addShakeAnimationForView(view: view, duration: duration)
        })
    }
    
    fileprivate func addShakeAnimationForView(view: UIView, duration: TimeInterval) {
        
        let animation = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        let currentTx = view.transform.tx
        animation.delegate = self
        animation.duration = duration
        animation.values = [
            currentTx,
            currentTx + 10,
            currentTx - 8,
            currentTx + 8,
            currentTx - 5,
            currentTx + 5,
            currentTx
        ]
        animation.keyTimes = [0, 0.225, 0.425, 0.6, 0.75, 0.875, 1]
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        view.layer.add(animation, forKey: kViewShakerAnimationKey)
    }
    
}

extension ViewShake: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        completedAnimations += 1
        if completedAnimations > (views?.count)! {
            completedAnimations = 0
            completionBlock?()
        }
    }
}
