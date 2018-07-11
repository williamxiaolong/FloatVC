//
//  XLVc.swift
//  FloatVC
//
//  Created by 袁小龙 on 2018/7/5.
//  Copyright © 2018年 袁小龙. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    func currentViewController() -> UIViewController {
        
        var vc = UIApplication.shared.keyWindow?.rootViewController
        
        while true {
            if (vc?.isKind(of: UITabBarController.classForCoder()))! {
                let newVc = vc as! UITabBarController
                vc = newVc.selectedViewController
                
            }
            
            if (vc?.isKind(of: UINavigationController.classForCoder()))! {
                let newVc = vc as! UINavigationController
                vc = newVc.visibleViewController
            }
            
            if vc?.presentedViewController != nil {
                vc = vc?.presentedViewController
            } else {
                break
            }
        }
        return vc!
        
    }
    
    func currentNavigationController() -> UINavigationController {
        return self.currentViewController().navigationController!
    }
    
}


