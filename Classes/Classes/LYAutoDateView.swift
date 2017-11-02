//
//  LYAutoDateView.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/17.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

protocol LYAutoDateViewDelegate: NSObjectProtocol {
    
    func changeDate(view: UIView, date: Date)
    func cancelAction(view: UIView)
    func sureAction(view: UIView)
    
}

enum LYAutoYMType {
    case year
    case month
}

class LYAutoDateView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    fileprivate weak var delegate: LYAutoDateViewDelegate?
    
    var date: Date!
    fileprivate var minDate: Date!
    fileprivate var maxDate: Date!
    fileprivate var mainColor: UIColor!
    
    fileprivate var yearLabel: UILabel!
    fileprivate var mdLabel: UILabel!
    fileprivate var days: UICollectionView!
    
    fileprivate var ymType: LYAutoYMType! = .month {
        didSet {
            days.reloadData()
            scrollToSelectedDate()
            
            if ymType == .year {
                yearLabel.textColor = .white
                mdLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
            }
            if ymType == .month {
                yearLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
                mdLabel.textColor = .white
            }
        }
    }
    
    fileprivate var daysPerWeek: Int = 7

    fileprivate var _calendar: Calendar!
    fileprivate func calendar(newValue: Calendar) {
        _calendar = newValue
        daysPerWeek = (_calendar.maximumRange(of: .weekday)?.count)!
    }
    fileprivate func calendar() -> Calendar {
        if _calendar == nil {
            _calendar = Calendar.current
        }
        return _calendar
    }
    
    fileprivate var _firstDateMonth: Date!
    fileprivate func firstDateMonth(newValue: Date) {
        _firstDateMonth = newValue
    }
    fileprivate func firstDateMonth() -> Date {
        if _firstDateMonth != nil {
            return _firstDateMonth
        }
        
        var components = calendar().dateComponents([.year, .month, .day, .hour, .minute, .second], from: minDate)
        components.day = 1
        _firstDateMonth = calendar().date(from: components)
        return _firstDateMonth

    }
    
    init(frame: CGRect,
                  delegate: LYAutoDateViewDelegate,
                  date: Date,
                  minDate: Date,
                  maxDate: Date,
                  mainColor: UIColor) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        self.delegate = delegate
        self.date = date
        self.minDate = minDate
        self.maxDate = maxDate
        self.mainColor = mainColor
        
        createViews()
        setDisplayDate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createViews() {
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 160))
        topView.backgroundColor = mainColor
        addSubview(topView)
        
        yearLabel = UILabel(frame: CGRect(x: 20, y: 0, width: bounds.width, height: 60))
        yearLabel.font = UIFont.systemFont(ofSize: 30.0)
        yearLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
        yearLabel.isUserInteractionEnabled = true
        topView.addSubview(yearLabel)
        
        mdLabel = UILabel(frame: CGRect(x: 20, y: 60, width: bounds.width, height: 100))
        mdLabel.font = UIFont.systemFont(ofSize: 50.0)
        mdLabel.textColor = .white
        mdLabel.isUserInteractionEnabled = true
        topView.addSubview(mdLabel)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(changeYearType(_:)))
        yearLabel.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(changeMonthType(_:)))
        mdLabel.addGestureRecognizer(tap2)
        
        let bottomView = UIView(frame: CGRect(x: 0, y: bounds.height-50, width: bounds.width, height: 50))
        bottomView.backgroundColor = .white
        addSubview(bottomView)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: bounds.width-160, y: 0, width: 80, height: 50)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitle("取消", for: .highlighted)
        cancelBtn.setTitleColor(mainColor, for: .normal)
        cancelBtn.setTitleColor(mainColor, for: .highlighted)
        cancelBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        bottomView.addSubview(cancelBtn)
        
        let sureBtn = UIButton(type: .custom)
        sureBtn.frame = CGRect(x: bounds.width-80, y: 0, width: 80, height: 50)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitle("确定", for: .highlighted)
        sureBtn.setTitleColor(mainColor, for: .normal)
        sureBtn.setTitleColor(mainColor, for: .highlighted)
        sureBtn.addTarget(self, action: #selector(sureAction(_:)), for: .touchUpInside)
        bottomView.addSubview(sureBtn)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        days = UICollectionView(frame: CGRect(x: 0, y: 160, width: bounds.width, height: bounds.height-210), collectionViewLayout: layout)
        days.backgroundColor = .white
        days.delegate = self
        days.dataSource = self
        days.showsVerticalScrollIndicator = false
        days.showsHorizontalScrollIndicator = false
        days.register(LYAutoDayCell.classForCoder(), forCellWithReuseIdentifier: "LYAutoDayCellId")
        days.register(LYAutoYearCell.classForCoder(), forCellWithReuseIdentifier: "LYAutoYearCellId")
        days.register(LYAutoMonthHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "LYAutoMonthHeaderId")
        addSubview(days)
    }
    
    func scrollToSelectedDate() {
        if date != nil {
            var selectedDateIndexPath: IndexPath!
            if ymType == .year {
                let curComponents = calendar().dateComponents([.year], from: date)
                let minComponents = calendar().dateComponents([.year], from: minDate)
                selectedDateIndexPath = IndexPath(item: curComponents.year!-minComponents.year!, section: 0)
            } else {
                selectedDateIndexPath = IndexPath(item: 0, section: sectionForDate(curDate: date))
            }
            if !days.indexPathsForVisibleItems.contains(selectedDateIndexPath) {
                let sectionLayoutAttributes = days.layoutAttributesForItem(at: selectedDateIndexPath)
                var origin = sectionLayoutAttributes?.frame.origin
                origin?.x = 0
                origin?.y -= (days.contentInset.top + 60)
                days.setContentOffset(origin!, animated: false)
            }
        }
    }
    
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        delegate?.cancelAction(view: self)
    }
    
    @objc fileprivate func sureAction(_ sender: UIButton) {
        delegate?.sureAction(view: self)
    }
    
    @objc fileprivate func changeYearType(_ tap: UITapGestureRecognizer) {
        if ymType != .year {
            ymType = .year
        }
    }
    
    @objc fileprivate func changeMonthType(_ tap: UITapGestureRecognizer) {
        if ymType != .month {
            ymType = .month
        }
    }
    
    //MARK: - UICollectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if ymType == .year {
            return 1
        } else {
            let months = calendar().dateComponents([.month], from: minDate, to: maxDate).month! + 1
            return months
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ymType == .year {
            let years = calendar().dateComponents([.year], from: minDate, to: maxDate).year! + 1
            return years
        } else {
            let firstOfMonth = firstDateOfMonth(index: section)
            let rangeOfWeeks = calendar().range(of: .weekOfMonth, in: .month, for: firstOfMonth)
            return (rangeOfWeeks?.count)! * daysPerWeek
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ymType == .year {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LYAutoYearCellId", for: indexPath) as! LYAutoYearCell
            cell.color = mainColor

            let minComponents = calendar().dateComponents([.year], from: minDate)
            let curComponents = calendar().dateComponents([.year], from: date)
            
            let curYear = minComponents.year! + indexPath.item
            
            cell.isSelect = curYear == curComponents.year!
            cell.title = String(curYear)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LYAutoDayCellId", for: indexPath) as! LYAutoDayCell
            cell.color = mainColor
            
            let firstOfMonth = firstDateOfMonth(index: indexPath.section)
            let cellDate = dateForCellAtIndexPath(indexPath: indexPath)
            
            let cellDateComponents = calendar().dateComponents([.year, .month, .day], from: cellDate)
            let firstOfMonthsComponents = calendar().dateComponents([.year, .month, .day], from: firstOfMonth)
            
            cell.isAble = isEnabledDate(curdate: cellDate)
            cell.isSelect = isSelectDate(curdate: cellDate)
            
            if cellDateComponents.month == firstOfMonthsComponents.month {
                let day = String(cellDateComponents.day!)
                cell.title = day
            } else {
                cell.title = ""
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if ymType == .year {
            return true
        } else {
            let firstOfMonth = firstDateOfMonth(index: indexPath.section)
            let cellDate = dateForCellAtIndexPath(indexPath: indexPath)
            
            if !isEnabledDate(curdate: cellDate) {
                return false
            }
            
            let cellDateComponents = calendar().dateComponents([.year, .month, .day], from: cellDate)
            let firstOfMonthsComponents = calendar().dateComponents([.year, .month, .day], from: firstOfMonth)
            
            return (cellDateComponents.month == firstOfMonthsComponents.month)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if ymType == .year {
            let minComponents = calendar().dateComponents([.year], from: minDate)
            let curYear = minComponents.year! + indexPath.item
            
            var curComponents = calendar().dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            curComponents.year = curYear
            delegate?.changeDate(view: self, date: calendar().date(from: curComponents)!)
            setDisplayDate()
            ymType = .month
        } else {
            let cellDate = dateForCellAtIndexPath(indexPath: indexPath)
            let oldComponents = calendar().dateComponents([.hour, .minute, .second], from: date)
            var newComponents = calendar().dateComponents([.year, .month, .day, .hour, .minute, .second], from: cellDate)
            newComponents.hour = oldComponents.hour
            newComponents.minute = oldComponents.minute
            newComponents.second = oldComponents.second
            let newDate = calendar().date(from: newComponents)
            setCurrentDate(curDate: newDate!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "LYAutoMonthHeaderId", for: indexPath) as! LYAutoMonthHeader
            
            let firstOfMonth = firstDateOfMonth(index: indexPath.section)
            let firstOfMonthsComponents = calendar().dateComponents([.year, .month, .day], from: firstOfMonth)

            let title = String(firstOfMonthsComponents.year!) + "年" + String(firstOfMonthsComponents.month!) + "月"
            header.setMonth(title: title)
            
            return header
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if ymType == .year {
            return CGSize(width: collectionView.bounds.width, height: 60)
        } else {
            let width = collectionView.bounds.width / 7
            return CGSize(width: width, height: width*0.8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if ymType == .year {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 60)
        }
    }
    
    //MARK: - Calendar Methods
    fileprivate func firstDateOfMonth(index: Int) -> Date {
        var offset = DateComponents()
        offset.month = index
        return calendar().date(byAdding: offset, to: firstDateMonth())!
    }
    
    fileprivate func dateForCellAtIndexPath(indexPath: IndexPath) -> Date {
        let firstOfMonth = firstDateOfMonth(index: indexPath.section)
        
        let weekday = calendar().dateComponents([.weekday], from: firstOfMonth).weekday
        var startOffset = weekday! - calendar().firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        
        var dateComponents = DateComponents()
        dateComponents.day = indexPath.item - startOffset
        
        return calendar().date(byAdding: dateComponents, to: firstOfMonth)!
    }
    
    fileprivate func isEnabledDate(curdate: Date) -> Bool {
        return curdate >= minDate && curdate <= maxDate
    }
    
    fileprivate func isSelectDate(curdate: Date) -> Bool {
        if date == nil {
            return false
        }
        
        let oldComponents = calendar().dateComponents([.year, .month, .day], from: date)
        let oldDate = calendar().date(from: oldComponents)
        let newComponents = calendar().dateComponents([.year, .month, .day], from: curdate)
        let newDate = calendar().date(from: newComponents)
        
        return oldDate == newDate
    }
    
    fileprivate func sectionForDate(curDate: Date) -> Int {
        return calendar().dateComponents([.month], from: firstDateMonth(), to: curDate).month!
    }
    
    fileprivate func indexPathForDate(curDate: Date) -> IndexPath {
        let section = sectionForDate(curDate: curDate)
        let firstOfMonth = firstDateOfMonth(index: section)
        
        let weekday = calendar().dateComponents([.weekday], from: firstOfMonth).weekday
        var startOffset = weekday! - calendar().firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        
        let day = calendar().dateComponents([.year, .month, .day], from: curDate).day

        let item = day! - 1 + startOffset

        return IndexPath(item: item, section: section)
    }
    
    fileprivate func setCurrentDate(curDate: Date) {
        
        let oldCell = days.cellForItem(at: indexPathForDate(curDate: date))
        let newCell = days.cellForItem(at: indexPathForDate(curDate: curDate)) as! LYAutoDayCell
        
        if oldCell != nil {
            let cell = oldCell as! LYAutoDayCell
            cell.isSelect = false
        }
        newCell.isSelect = true
        
        delegate?.changeDate(view: self, date: curDate)
        setDisplayDate()
    }
    
    fileprivate func setDisplayDate() {
        let dateComponents = calendar().dateComponents([.year, .month, .day], from: date)
        
        yearLabel.text = String(dateComponents.year!) + "年"
        mdLabel.text = String(dateComponents.month!) + "月" + String(dateComponents.day!) + "日"
    }
    
}
