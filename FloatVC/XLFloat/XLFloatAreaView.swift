//
//  XLFloatAreaView.swift
//  FloatVC
//
//  Created by 袁小龙 on 2018/7/5.
//  Copyright © 2018年 袁小龙. All rights reserved.
//

import UIKit

enum XLFloatAreaViewStyle {
    case XLFloatAreaViewStyle_default
    case XLFloatAreaViewStyle_cancel
}


class XLFloatAreaView: UIView {
    
    var title: NSString?
    var radius_0: CGFloat = 18
    var radius_1: CGFloat = 10
    var coef: CGFloat = 0.95
    var style: XLFloatAreaViewStyle? {
        didSet {
            if style == .XLFloatAreaViewStyle_default {
                self.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
                self.title = "拖动到此，开启浮窗"
            } else if style == .XLFloatAreaViewStyle_cancel {
                self.backgroundColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.8)
                self.title = "拖动到此，关闭浮窗"
            }
        }
    }
    
    var highlight: Bool = false {
        
        didSet {
            
            if style == .XLFloatAreaViewStyle_default {
                self.title = highlight ? "释放开启浮窗" : "拖动到此，开启浮窗"
            } else if style == .XLFloatAreaViewStyle_cancel {
                self.title = highlight ? "释放关闭浮窗" : "拖动到此，关闭浮窗"
            }
            
            if highlight {
                if #available(iOS 10.0, *) {
                    let impactLight = UIImpactFeedbackGenerator.init(style: .medium)
                    impactLight.impactOccurred()
                } else {
                    // Fallback on earlier versions
                }
                
            }
            
            self.setNeedsDisplay()
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8)
        self.title = "拖动到此，开启浮窗"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        self.radius_0 = self.highlight ? 20 : 18
        self.radius_1 = self.highlight ? 12 : 10
        self.coef = self.highlight ? 1 : 0.95
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        //1/4扇形
        let bezierPath = UIBezierPath.init(arcCenter: CGPoint(x: width, y: width), radius: width * self.coef, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI) * 1.5, clockwise: true)
        bezierPath.addLine(to: CGPoint(x: width, y: width))
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle : textStyle]
        self.title?.draw(in: CGRect(x: 0, y: height * 3 / 4, width: width, height: 20), withAttributes: attributes)
        
        //内圆
        let bezierpath0 = UIBezierPath.init(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: self.radius_0, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        bezierpath0.lineWidth = 3
        bezierpath0.stroke()
        
        //外圆
        let bezierpath1 = UIBezierPath.init(arcCenter: CGPoint(x: width / 2, y: height / 2), radius: self.radius_1, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        bezierpath1.lineWidth = 3
        bezierpath1.stroke()
        
        //斜线
        if style == .XLFloatAreaViewStyle_cancel {
            let bezierpath2 = UIBezierPath()
            let startPoint2 = CGPoint(x: (width / 2) - self.radius_0, y: (height / 2) - self.radius_0)
            let endPoint2 = CGPoint(x: (width / 2) + self.radius_0, y: (height / 2) + self.radius_0)
            bezierpath2.move(to: startPoint2)
            bezierpath2.addLine(to: endPoint2)
            bezierpath2.lineWidth = 3
            bezierpath2.lineJoinStyle = .bevel
            bezierpath2.stroke()
        }
        
    }
 

}
