//
//  XLTransitionPop.swift
//  FloatVC
//
//  Created by 袁小龙 on 2018/7/9.
//  Copyright © 2018年 袁小龙. All rights reserved.
//

import UIKit

class XLTransitionPop: NSObject {
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    lazy var coverView: UIView = {
        let obj = UIView.init(frame: UIScreen.main.bounds)
        obj.backgroundColor = UIColor.black
        obj.alpha = 0.5
        return obj
    }()

}

extension XLTransitionPop: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return xTimeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        let contView = transitionContext.containerView
        contView.addSubview((toVC?.view)!)
        contView.addSubview((fromVC?.view)!)
        
        let floatBallRect = FloatManager.shareFloatManager.floatBall.frame
        toVC?.view.addSubview(self.coverView)
        
        let startBezierPath = UIBezierPath.init(roundedRect: CGRect(x: floatBallRect.origin.x, y: floatBallRect.origin.y, width: floatBallRect.size.width, height: floatBallRect.size.height), cornerRadius: floatBallRect.size.width / 2)
        let finishBezierPath = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: UISCREEN_WIDTH, height: UISCREEN_HEIGHT), cornerRadius: floatBallRect.size.width / 2)
        
        let layer = CAShapeLayer()
        layer.path = startBezierPath.cgPath
        fromVC?.view.layer.mask = layer
        
        let layerAnimation = CABasicAnimation(keyPath: "path")
        layerAnimation.toValue = startBezierPath.cgPath
        layerAnimation.fromValue = finishBezierPath.cgPath
        layerAnimation.duration = xTimeInterval
        layerAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        layerAnimation.delegate = self
        layer.add(layerAnimation, forKey: "path")
        
        UIView.animate(withDuration: xTimeInterval) {
            self.coverView.alpha = 0
            FloatManager.shareFloatManager.floatBall.alpha = 1
        }
    }
    
    
}

extension XLTransitionPop: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(true)
        self.transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
        self.transitionContext?.viewController(forKey: .to)?.view.layer.mask = nil
        self.coverView.removeFromSuperview()
    }
    
}

