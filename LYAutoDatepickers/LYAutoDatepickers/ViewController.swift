//
//  ViewController.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit
import SwiftDate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var dateLabel: UILabel!

    @IBAction func pickDate(_ sender: UIButton) {
        //1483200000 1388505600 28800 14400 43200
        LYAutoDatepickers.showDatepicker(type: .YMDHmS,
                                         vc: self,
                                         date: Date(),
                                         minDate: nil,
                                         maxDate: nil)
        { (date) in
            self.dateLabel.text = date.description(with: Locale.current)
        }
    }

}

