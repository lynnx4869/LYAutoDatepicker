//
//  LYAutoYearCell.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoYearCell: UITableViewCell {
    
    public var year: String = "" {
        didSet {
            yearLabel.text = year
        }
    }
    
    public var isSelect: Bool = false {
        didSet {
            if isSelect {
                yearBg.isHidden = false
                yearLabel.textColor = .white
            } else {
                yearBg.isHidden = true
                //#333333
                yearLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
            }
        }
    }
    
    @IBOutlet fileprivate weak var yearLabel: UILabel!
    @IBOutlet fileprivate weak var yearBg: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        yearBg.layer.cornerRadius = 35.0
        yearBg.layer.masksToBounds = true
    }
    
}
