//
//  ViewController.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/31.
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
    
    @IBAction func datePick(_ sender: UIButton) {
//                date: Date(timeIntervalSince1970: 1508310074),
//                minDate: Date(timeIntervalSince1970: 1502150400),
//                maxDate: Date(timeIntervalSince1970: 1513080000),
        
        //        date: nil,
        //        minDate: nil,
        //        maxDate: nil,
        
        //Date(timeIntervalSince1970: 1508342399)
        //1508342400
        
        //0x3a4a4a
        
        LYAutoDatepickers.show(type: .YMDHmS,
                               vc: self,
                               date: Date(timeIntervalSince1970: 1508310074),
                               minDate: Date(timeIntervalSince1970: 1265070000),
                               maxDate: Date(timeIntervalSince1970: 1670841600),
                               mainColor: UIColor.color(hex: 0xff9000))
        { (date) in
            debugPrint(date.description(with: Locale.current))
        }
    }
    

}

