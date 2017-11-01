//
//  LYAutoDayCell.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/17.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoDayCell: UICollectionViewCell {
    
    var color: UIColor!
    var title: String!{
        didSet {
            dayLabel.text = title
        }
    }
    var isSelect: Bool! {
        didSet {
            if isAble {
                if isSelect {
                    dayLabel.textColor = .white
                    dayLabel.backgroundColor = color
                } else {
                    dayLabel.textColor = UIColor.color(hex: 0x333333)
                    dayLabel.backgroundColor = .white
                }
            }
        }
    }
    var isAble: Bool! {
        didSet {
            if isAble {
                dayLabel.textColor = UIColor.color(hex: 0x333333)
                dayLabel.backgroundColor = .white
            } else {
                dayLabel.textColor = UIColor.color(hex: 0x999999)
                dayLabel.backgroundColor = .white
            }
        }
    }
    
    fileprivate var dayLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = contentView.bounds.width * 0.8
        
        dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        dayLabel.center = contentView.center
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 16)
        dayLabel.layer.cornerRadius = width / 2
        dayLabel.layer.masksToBounds = true
        contentView.addSubview(dayLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
