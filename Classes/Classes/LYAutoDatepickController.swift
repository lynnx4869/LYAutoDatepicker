//
//  LYAutoDatepickController.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/16.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

class LYAutoDatepickController: UIViewController, LYAutoDateViewDelegate {
    
    open var type: LYAutoDateType = .YMD
    open var date: Date! = Date()
    open var minDate: Date! = Date(timeIntervalSince1970: -2209017600)
    open var maxDate: Date! = Date(timeIntervalSince1970: 4132310400)
    open var mainColor: UIColor! = UIColor.color(hex: 0xff9000)
    open var callback: (Date)->Void = { _ in }
    
    fileprivate var dateView: LYAutoDateView!
    fileprivate var timeView: LYAutoTimeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let bgView = UIView(frame: view.bounds)
        bgView.backgroundColor = UIColor.color(hex: 0x000000, alpha: 0.6)
        view.addSubview(bgView)
        
        if type == .YMDHmS {
            dateView = LYAutoDateView(frame: CGRect(x: 0, y: 0, width: 280, height: 500),
                                      delegate: self,
                                      date: date,
                                      minDate: minDate,
                                      maxDate: maxDate,
                                      mainColor: mainColor)
            dateView.center = view.center
            view.addSubview(dateView)
            
            timeView = LYAutoTimeView(frame: CGRect(x: 0, y: 0, width: 280, height: 430),
                                      delegate: self,
                                      date: date,
                                      minDate: minDate,
                                      maxDate: maxDate,
                                      mainColor: mainColor)
            timeView.center = view.center
            view.addSubview(timeView)
            
            timeView.isHidden = true
        } else if type == .YMD {
            dateView = LYAutoDateView(frame: CGRect(x: 0, y: 0, width: 280, height: 500),
                                      delegate: self,
                                      date: date,
                                      minDate: minDate,
                                      maxDate: maxDate,
                                      mainColor: mainColor)
            dateView.center = view.center
            view.addSubview(dateView)
        } else if type == .HmS {
            timeView = LYAutoTimeView(frame: CGRect(x: 0, y: 0, width: 280, height: 430),
                                      delegate: self,
                                      date: date,
                                      minDate: minDate,
                                      maxDate: maxDate,
                                      mainColor: mainColor)
            timeView.center = view.center
            view.addSubview(timeView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dateView != nil {
            dateView.scrollToSelectedDate()
        }
    }
    
    func changeDate(view: UIView, date: Date) {
        if date >= minDate && date <= maxDate {
            self.date = date
        } else if date < minDate {
            self.date = minDate
        } else {
            self.date = maxDate
        }
        
        if type == .YMDHmS {
            dateView.date = self.date
            timeView.date = self.date
        } else if type == .YMD {
            dateView.date = self.date
        } else if type == .HmS {
            timeView.date = self.date
        }
    }
    
    func cancelAction(view: UIView) {
        if type == .YMDHmS {
            if view == dateView {
                dismiss(animated: false, completion: nil)
            } else if view == timeView {
                dateView.isHidden = false
                timeView.isHidden = true
            }
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    
    func sureAction(view: UIView) {
        if type == .YMDHmS {
            if view == dateView {
                dateView.isHidden = true
                timeView.isHidden = false
            } else if view == timeView {
                callback(date)
                dismiss(animated: false, completion: nil)
            }
        } else {
            callback(date)
            dismiss(animated: false, completion: nil)
        }
    }
    
}
