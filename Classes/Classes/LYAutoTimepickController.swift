//
//  LYAutoTimepickController.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit
import SnapKit
import SwiftDate

class LYAutoTimepickController: LYAutoPickBaseController {

    @IBOutlet fileprivate weak var hourLabel: UILabel!
    @IBOutlet fileprivate weak var minuteLabel: UILabel!
    @IBOutlet fileprivate weak var clockView: UIView!
    
    fileprivate let ahc = LYAutoHourClock()
    fileprivate let amc = LYAutoMinuteClock()
    
    fileprivate var isHour: Bool! {
        didSet {
            if isHour {
                ahc.isHidden = false
                amc.isHidden = true
            } else {
                ahc.isHidden = true
                amc.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hourLabel.text = String(date.hour)
        minuteLabel.text = String(date.minute)
        
        ahc.currentTime = date.hour
        ahc.selectBlock = { [weak self] (time: Int) in
            if (self?.isHour)! {
                self?.hourLabel.text = String(time)
                
                let c: [Calendar.Component : Int] = [.year: (self?.date.year)!,
                                                     .month: (self?.date.month)!,
                                                     .day: (self?.date.day)!,
                                                     .hour: time,
                                                     .minute: (self?.date.minute)!,
                                                     .second: 0,
                                                     .nanosecond: 0]
                let date = DateInRegion(components: c, fromRegion: nil)
                self?.date = date?.absoluteDate
            }
        }
        clockView.addSubview(ahc)
        
        ahc.snp.makeConstraints({ (make) in
            make.edges.equalTo(clockView).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        })
        
        amc.currentTime = date.minute
        amc.selectBlock = { [weak self] (time: Int) in
            if !(self?.isHour)! {
                self?.minuteLabel.text = String(time)
                
                let c: [Calendar.Component : Int] = [.year: (self?.date.year)!,
                                                     .month: (self?.date.month)!,
                                                     .day: (self?.date.day)!,
                                                     .hour: (self?.date.hour)!,
                                                     .minute: time,
                                                     .second: 0,
                                                     .nanosecond: 0]
                let date = DateInRegion(components: c, fromRegion: nil)
                self?.date = date?.absoluteDate
            }
        }
        clockView.addSubview(amc)
        
        amc.snp.makeConstraints({ (make) in
            make.edges.equalTo(clockView).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        })
        
        isHour = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("LY Auto Time Picker dealloc ...")
    }
    
    //MARK: - events
    @IBAction func clickToCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickToSure(_ sender: Any) {
        if isHour {
            isHour = false
        } else {
            block(date)
            dismiss(animated: true, completion: nil)
        }
    }
}
