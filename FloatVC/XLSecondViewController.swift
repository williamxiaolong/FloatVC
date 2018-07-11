//
//  XLSecondViewController.swift
//  FloatVC
//
//  Created by 袁小龙 on 2018/7/5.
//  Copyright © 2018年 袁小龙. All rights reserved.
//

import UIKit

class XLSecondViewController: UIViewController {

    var image: UIImage?
    
    @objc var xlIconImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.purple
        
        if let image = image {
            let imageView = UIImageView.init(frame: self.view.bounds)
            imageView.image = image
            self.view.addSubview(imageView)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
