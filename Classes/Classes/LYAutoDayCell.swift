//
//  LYAutoDayCell.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/10.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoDayCell: UICollectionViewCell {
    
    public var isAble: Bool! = true {
        didSet {
            if isAble {
                //#333333
                dayLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            } else {
                //#CCCCCC
                dayLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            }
            
            dayBg.isHidden = true
        }
    }
    
    public var isSelect: Bool! = false {
        didSet {
            if isSelect {
                dayLabel.textColor = .white
                dayBg.isHidden = false
            }
        }
    }
    
    public var day: String! {
        didSet {
            dayLabel.text = day
        }
    }

    @IBOutlet fileprivate weak var dayBg: UIView!
    @IBOutlet fileprivate weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dayBg.backgroundColor = LYDatepickColor
        dayBg.layer.masksToBounds = true
        dayBg.layer.cornerRadius = 12.5
        dayBg.isHidden = !isSelect
    }

}
