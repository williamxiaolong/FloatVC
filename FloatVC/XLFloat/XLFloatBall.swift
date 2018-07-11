//
//  XLFloatBall.swift
//  FloatVC
//
//  Created by 袁小龙 on 2018/7/6.
//  Copyright © 2018年 袁小龙. All rights reserved.
//

import UIKit

let margin:CGFloat = 10


protocol XLFloatBallDelegate: NSObjectProtocol {
    
    func floatBallBeginMove()
    
    func floatBallEndMove()
    
    func floatBallClick()
    
}

class XLFloatBall: UIView {

    weak var delegate: XLFloatBallDelegate?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView.init(frame: self.bounds)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(self.imageView!)
        
        self.backgroundColor = UIColor.purple
        self.layer.borderWidth = 6
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ballClick))
        self.addGestureRecognizer(tap)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for obj in touches {
            
            self.center = obj.location(in: UIApplication.shared.keyWindow)
            if self.delegate != nil {
                self.delegate?.floatBallBeginMove()
            }
            
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endTouch(touces: touches)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.endTouch(touces: touches)

    }
    
    //手势结束时对视图位置重新设定
    func endTouch(touces: Set<UITouch>) {
        var frame = self.frame
        let navHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 44
        for obj in touces {
            let point = obj.location(in: UIApplication.shared.keyWindow)
            if point.x > (UISCREEN_WIDTH / 2) {
                frame.origin.x = UISCREEN_WIDTH - frame.size.width - margin
            } else {
                frame.origin.x = margin
            }
            
            if frame.origin.y > (UISCREEN_HEIGHT - frame.size.height - margin) {
                frame.origin.y = UISCREEN_HEIGHT - frame.size.height - margin
            } else if frame.origin.y < navHeight {
                frame.origin.y = navHeight
            }
            
            UIView.animate(withDuration: 0.3) {
                self.frame = frame
            }
        }
        
        if self.delegate != nil {
            self.delegate?.floatBallEndMove()
        }
        
    }
    
     @objc private func ballClick() {
        
        if self.delegate != nil {
            self.delegate?.floatBallClick()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
