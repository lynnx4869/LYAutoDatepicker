//
//  LYAutoTimeView.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/19.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoTimeView: UIView, LYAutoClockViewDelegate {
    
    fileprivate weak var delegate: LYAutoDateViewDelegate?
    
    var date: Date! {
        didSet {
            if clockView != nil {
                clockView.date = date
            }
            
            setDisplayDate()
        }
    }
    fileprivate var minDate: Date!
    fileprivate var maxDate: Date!
    fileprivate var mainColor: UIColor!
    
    fileprivate var hourLabel: UILabel!
    fileprivate var minuteLabel: UILabel!
    
    fileprivate var clockView: LYAutoClockView!
    
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
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 100))
        topView.backgroundColor = mainColor
        addSubview(topView)
        
        let width = (bounds.width - 16) / 2
        
        hourLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 100))
        hourLabel.font = UIFont.systemFont(ofSize: 50.0)
        hourLabel.textColor = .white
        hourLabel.textAlignment = .right
        hourLabel.isUserInteractionEnabled = true
        topView.addSubview(hourLabel)
        
        let colonLabel = UILabel(frame: CGRect(x: width, y: 0, width: 16, height: 100))
        colonLabel.font = UIFont.systemFont(ofSize: 50.0)
        colonLabel.textColor = .white
        colonLabel.text = ":"
        topView.addSubview(colonLabel)
        
        minuteLabel = UILabel(frame: CGRect(x: width+16, y: 0, width: width, height: 100))
        minuteLabel.font = UIFont.systemFont(ofSize: 50.0)
        minuteLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
        minuteLabel.isUserInteractionEnabled = true
        topView.addSubview(minuteLabel)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(changeHourLabel(_:)))
        hourLabel.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(changeMinuteLabel(_:)))
        minuteLabel.addGestureRecognizer(tap2)
        
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
        
        clockView = LYAutoClockView(frame: CGRect(x: 0,
                                                  y: 100,
                                                  width: bounds.width,
                                                  height: bounds.width),
                                    delegate: self,
                                    date: date,
                                    minDate: minDate,
                                    maxDate: maxDate,
                                    mainColor: mainColor)
        addSubview(clockView)
    }
    
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        delegate?.cancelAction(view: self)
    }
    
    @objc fileprivate func sureAction(_ sender: UIButton) {
        delegate?.sureAction(view: self)
    }
    
    @objc fileprivate func changeHourLabel(_ tap: UITapGestureRecognizer) {
        let type = clockView.moveType
        
        if type == .minute {
            hourLabel.textColor = .white
            minuteLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
            clockView.moveType = .hour
        }
    }
    
    @objc fileprivate func changeMinuteLabel(_ tap: UITapGestureRecognizer) {
        let type = clockView.moveType

        if type == .hour {
            hourLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
            minuteLabel.textColor = .white
            clockView.moveType = .minute
        }
    }
    
    func changeClock(time: Int, type: LYAutoClockMoveType) {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        if type == .hour {
            dateComponents.hour = time
        }
        
        if type == .minute {
            dateComponents.minute = time
        }
        date = Calendar.current.date(from: dateComponents)!

        setDisplayDate()
        delegate?.changeDate(view: self, date: date)
    }
    
    func changeMoveType(type: LYAutoClockMoveType) {
        if type == .hour {
            hourLabel.textColor = .white
            minuteLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
        }
        
        if type == .minute {
            hourLabel.textColor = UIColor.color(hex: 0xffffff, alpha: 0.5)
            minuteLabel.textColor = .white
        }
    }
    
    //MARK: - MARK: - Time Methods
    fileprivate func setDisplayDate() {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        hourLabel.text = getTwoNum(num: String(dateComponents.hour!))
        minuteLabel.text = getTwoNum(num: String(dateComponents.minute!))
    }
    
    fileprivate func getTwoNum(num: String) -> String {
        if num.count.hashValue >= 2 {
            return num
        } else {
            return "0" + num
        }
    }
    
}
