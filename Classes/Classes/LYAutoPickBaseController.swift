//
//  LYAutoPickBaseController.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoPickBaseController: UIViewController {
    
    public var type: LYAutoDateType = .YMD
    public var date: Date! = Date()
    public var maxDate: Date?
    public var minDate: Date?
    public var block: (_: Date)->Void = { _ in }
    public var presentVc: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
