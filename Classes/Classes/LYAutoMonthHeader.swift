//
//  LYAutoMonthHeader.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/17.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoMonthHeader: UICollectionReusableView {
    
    fileprivate var monthLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 35))
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.systemFont(ofSize: 20)
        monthLabel.textColor = UIColor.color(hex: 0x333333)
        addSubview(monthLabel)
        
        let weeks = ["日", "一", "二", "三", "四", "五", "六"]
        for i in 0...6 {
            let weekLabel = UILabel(frame: CGRect(x: CGFloat(i)*bounds.width/7, y: 35, width: bounds.width/7, height: 25))
            weekLabel.textAlignment = .center
            weekLabel.font = UIFont.systemFont(ofSize: 16)
            weekLabel.textColor = UIColor.color(hex: 0x555555)
            weekLabel.text = weeks[i]
            addSubview(weekLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMonth(title: String) {
        monthLabel.text = title
    }
    
}
