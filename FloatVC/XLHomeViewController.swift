//
//  XLHomeViewController.swift
//  FloatVC
//
//  Created by 袁小龙 on 2018/7/5.
//  Copyright © 2018年 袁小龙. All rights reserved.
//

import UIKit

class XLHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "朋友"
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(self.tableView)
    }
    
    lazy var tableView: UITableView = {
        let tb = UITableView.init(frame: self.view.bounds, style: .plain)
        tb.separatorInset = UIEdgeInsets.zero
        tb.delegate = self
        tb.dataSource = self
        tb.rowHeight = UITableViewAutomaticDimension
        return tb
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: UITableViewDelegate,UITableViewDataSource
extension XLHomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = "homeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellName)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellName)
        }
        cell?.textLabel?.text = "朋友" + "\(indexPath.row)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = XLFirstViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
