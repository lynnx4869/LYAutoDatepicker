//
//  ViewController.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickDate(_ sender: UIButton) {
        //1483200000 1388505600
        LYAutoDatepickers.showDatepicker(type: .HmS,
                                         vc: self,
                                         date: Date(timeIntervalSince1970: 28800),
                                         minDate: Date(timeIntervalSince1970: 14400),
                                         maxDate: Date(timeIntervalSince1970: 43200))
        { (date) in
            print(date.timeIntervalSince1970)
        }
    }

}

