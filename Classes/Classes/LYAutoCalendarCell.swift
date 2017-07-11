//
//  LYAutoCalendarCell.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit
import SwiftDate

public protocol LYAutoCalendarDelegate: class {
    
    func getSelectDay(date: Date)
    
}

class LYAutoCalendarCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var date: Date!
    public var maxDate: Date!
    public var minDate: Date!
    public var currentMonth: Date! {
        didSet {
            monthTitle.text = String(currentMonth.year) + "年" + String(currentMonth.month) + "月"
            days.reloadData()
        }
    }
    
    public weak var delegate: LYAutoCalendarDelegate?
    
    @IBOutlet fileprivate weak var monthTitle: UILabel!
    @IBOutlet fileprivate weak var days: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        
        days.delegate = self
        days.dataSource = self
        days.register(UINib(nibName: "LYAutoDayCell", bundle: .main), forCellWithReuseIdentifier: "LYAutoDayCellId")
    }
    
    //MARK: - UICollectionViewDelegate
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentMonth.monthDays + currentMonth.weekday - 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/7, height: 30)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LYAutoDayCellId", for: indexPath) as! LYAutoDayCell
        
        if indexPath.item >= currentMonth.weekday - 1 {
            let curDay = currentMonth + (indexPath.item-currentMonth.weekday+1).day
            
            if curDay < minDate || curDay > maxDate {
                cell.isAble = false
            } else {
                cell.isAble = true
            }
            
            if curDay.isInSameDayOf(date: date) {
                cell.isSelect = true
            } else {
                cell.isSelect = false
            }
            
            cell.day = String(indexPath.row - currentMonth.weekday + 2)
        } else {
            cell.isAble = false
            cell.isSelect = false
            cell.day = ""
        }
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LYAutoDayCell
        if cell.isAble && !cell.isSelect {
            let curDay = currentMonth + (indexPath.item-currentMonth.weekday+1).day
            delegate?.getSelectDay(date: curDay)
        }
    }
    
}
