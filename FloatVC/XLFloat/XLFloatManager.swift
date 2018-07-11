//
//  XLFloatManager.swift
//  FloatVC
//
//  Created by 袁小龙 on 2018/7/5.
//  Copyright © 2018年 袁小龙. All rights reserved.
//

import Foundation
import UIKit

let xFloatAreaR: CGFloat = UISCREEN_WIDTH * 0.45
let xFloatMargin: CGFloat = 30
let xCoef: CGFloat = 1.2
let xBallSizeR: CGFloat = 60


class FloatManager: NSObject {
    
    static let shareFloatManager = FloatManager()
    
    let kWindow = UIApplication.shared.keyWindow
    var floatVcClass = [String]()
    var edgePan: UIScreenEdgePanGestureRecognizer?
    var floatVC: UIViewController?
    var tempFloatVC: UIViewController?
    var showFloatBall: Bool = false {
        didSet {
            
            self.floatArea.highlight = showFloatBall
        }
        
    }
    
    //定时器
    lazy var link: CADisplayLink = {
        let obj = CADisplayLink.init(target: self, selector: #selector(panBack(currentLink:)))
        obj.add(to: RunLoop.main, forMode: .commonModes)
        obj.isPaused = true
        return obj
    }()
    
    //开启浮窗1/4圆
    lazy var floatArea: XLFloatAreaView = {
        let obj = XLFloatAreaView.init(frame: CGRect.init(x: UISCREEN_WIDTH + xFloatMargin, y: UISCREEN_HEIGHT + xFloatMargin, width: xFloatAreaR, height: xFloatAreaR))
        obj.style = .XLFloatAreaViewStyle_default
        return obj
    }()
    
    //移除浮窗1/4圆
    lazy var cancelFloatAreaView: XLFloatAreaView = {
        let obj = XLFloatAreaView.init(frame: CGRect.init(x: UISCREEN_WIDTH + xFloatMargin, y: UISCREEN_HEIGHT + xFloatMargin, width: xFloatAreaR, height: xFloatAreaR))
        obj.style = .XLFloatAreaViewStyle_cancel
        return obj
    }()
    
    //圆形浮窗
    lazy var floatBall: XLFloatBall = {
        let obj = XLFloatBall.init(frame: CGRect(x: UISCREEN_WIDTH - xBallSizeR - 15, y: UISCREEN_HEIGHT / 3, width: xBallSizeR, height: xBallSizeR))
        obj.delegate = self
        return obj
    }()
    
    override init() {
        super.init()
        
        self.currentNavigationController().interactivePopGestureRecognizer?.delegate = self
        self.currentNavigationController().delegate = self
    }
    
    @objc func panBack(currentLink: CADisplayLink) {
        print("------")
        if self.edgePan?.state == UIGestureRecognizerState.changed {
            let tPoint = self.edgePan?.translation(in: kWindow)
            let x = max(UISCREEN_WIDTH + xFloatMargin - xCoef * (tPoint?.x)!, UISCREEN_WIDTH - xFloatAreaR)
            let y = max(UISCREEN_HEIGHT + xFloatMargin - xCoef * (tPoint?.x)!, UISCREEN_HEIGHT - xFloatAreaR)
            let rect = CGRect.init(x: x, y: y, width: xFloatAreaR, height: xFloatAreaR)
            self.floatArea.frame = rect
            let touchPoint = kWindow?.convert((self.edgePan?.location(in: kWindow))!, to: self.floatArea)
            print("touchPoint==\(touchPoint)")
            if ((touchPoint?.x)! > CGFloat(0) && (touchPoint?.y)! > CGFloat(0)) {
                
                if (pow(xFloatAreaR - (touchPoint?.x)!, 2) + pow(xFloatAreaR - (touchPoint?.y)!, 2) <= pow(xFloatAreaR, 2)) {
                    if (self.showFloatBall == false) {
                        self.showFloatBall = true
                    }
                } else {
                    if self.showFloatBall {
                        self.showFloatBall = false
                    }
                }
                
            } else {
                if self.showFloatBall {
                    self.showFloatBall = false
                }
            }
        } else if self.edgePan?.state == UIGestureRecognizerState.possible {
            UIView.animate(withDuration: 0.5, animations: {
                self.floatArea.frame = CGRect(x: UISCREEN_WIDTH, y: UISCREEN_HEIGHT, width: xFloatAreaR, height: xFloatAreaR)
            }) { (finished) in
                self.floatArea.removeFromSuperview()
                self.link.isPaused = true
                if self.showFloatBall {
                    self.floatVC = self.tempFloatVC
                    if self.haveIconImage() {
                        
                        let image = self.floatVC?.value(forKey: "xlIconImage")
                        if image != nil {
                            self.floatBall.imageView?.image = (image as! UIImage)
                        }
                    }
                    self.floatBall.frame = CGRect(x: UISCREEN_WIDTH - xBallSizeR - 15, y: UISCREEN_HEIGHT / 3, width: xBallSizeR, height: xBallSizeR)
                    self.floatBall.alpha = 1
                    self.kWindow?.addSubview(self.floatBall)
                }
                
            }
            
        }
        
    }
    
    private func haveIconImage() -> Bool {
        var have = false
        
        var count:UInt32 = 0
        let list = class_copyIvarList(self.floatVC?.classForCoder, &count)
        
        for i in 0..<count {
            let pty = list![Int(i)]
            let nameChar = ivar_getName(pty)
            let name = String.init(utf8String: nameChar!)
            print("name=\(name)")
            if name == "xlIconImage" {
                have = true
            }
            
        }
        free(list)
        
        return have
        
    }
    
    class func addFloatVcClass(vcClass: [String]?) {
        
        for obj in vcClass! {
            
            if shareFloatManager.floatVcClass.contains(obj) == false {
                shareFloatManager.floatVcClass.append(obj)
            }
        }
        
    }
    
    func beginScreenEdgePanBack(ges: UIGestureRecognizer) {
        
        if self.floatVcClass.contains("\(self.currentViewController().classForCoder)") {
            self.edgePan = ges as! UIScreenEdgePanGestureRecognizer
            self.link.isPaused = false
            kWindow?.addSubview(self.floatArea)
            self.tempFloatVC = self.currentViewController()
            
        }
        
    }
    
    
}

//MARK:UIGestureRecognizerDelegate
extension FloatManager : UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.currentNavigationController().viewControllers.count > 1 {
            self.beginScreenEdgePanBack(ges: gestureRecognizer)
            
            return true
        }
        return false
    }
    
}

//MARK:UINavigationControllerDelegate
extension FloatManager: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let vc = self.floatVC
        if vc != nil {
            
            if operation == UINavigationControllerOperation.push {
                if toVC == vc {
                    let transition = XLTransitionPush()
                    return transition
                }
            } else if operation == UINavigationControllerOperation.pop {
                if fromVC == vc {
                    let trantion = XLTransitionPop()
                    return trantion
                }
            }
        }
        return nil
    }
    
}

extension FloatManager: XLFloatBallDelegate {
    
    func floatBallBeginMove() {
        
        kWindow?.insertSubview(self.cancelFloatAreaView, at: 1)
        UIView.animate(withDuration: 0.5) {
            self.cancelFloatAreaView.frame = CGRect(x: UISCREEN_WIDTH - xFloatAreaR, y: UISCREEN_HEIGHT - xFloatAreaR, width: xFloatAreaR, height: xFloatAreaR)
        }
        
        let ballCenter = kWindow?.convert(self.floatBall.center, to: self.cancelFloatAreaView)
        if pow(xFloatAreaR - (ballCenter?.x)!, 2) + pow(xFloatAreaR - (ballCenter?.y)!, 2) <= pow(xFloatAreaR, 2) {
            if self.cancelFloatAreaView.highlight == false {
                self.cancelFloatAreaView.highlight = true
            }
        } else {
            if self.cancelFloatAreaView.highlight {
                self.cancelFloatAreaView.highlight = false
            }
        }
        
    }
    
    func floatBallEndMove() {
        
        if self.cancelFloatAreaView.highlight {
            self.tempFloatVC = nil
            self.floatVC = nil
            self.floatBall.removeFromSuperview()
            self.cancelFloatAreaView.highlight = false
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cancelFloatAreaView.frame = CGRect(x: UISCREEN_WIDTH, y: UISCREEN_HEIGHT, width: xFloatAreaR, height: xFloatAreaR)
        }) { (finished) in
            self.cancelFloatAreaView.removeFromSuperview()
        }
    }
    
    func floatBallClick() {
        
        self.currentNavigationController().pushViewController(self.floatVC!, animated: true)
        
    }
    
}

