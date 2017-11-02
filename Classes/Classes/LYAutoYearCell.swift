//
//  LYAutoYearCell.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/11/2.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoYearCell: UICollectionViewCell {
    
    var color: UIColor!
    var title: String!{
        didSet {
            yearLabel.text = title
        }
    }
    var isSelect: Bool! {
        didSet {
            if isSelect {
                yearLabel.textColor = .white
                yearLabel.backgroundColor = color
            } else {
                yearLabel.textColor = UIColor.color(hex: 0x333333)
                yearLabel.backgroundColor = .white
            }
        }
    }
    
    fileprivate var yearLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let width = contentView.bounds.height
        
        yearLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        yearLabel.center = contentView.center
        yearLabel.textAlignment = .center
        yearLabel.font = UIFont.systemFont(ofSize: 22)
        yearLabel.layer.cornerRadius = width / 2
        yearLabel.layer.masksToBounds = true
        contentView.addSubview(yearLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
