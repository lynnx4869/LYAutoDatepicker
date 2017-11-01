//
//  LYAutoDatepickers.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/16.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

public enum LYAutoDateType {
    case YMD
    case HmS
    case YMDHmS
}

open class LYAutoDatepickers {
    
    /// 展示时间选择器
    ///
    /// - Parameters:
    ///   - type: 选择器种类
    ///   - vc: 展示界面
    ///   - date: 当前日期
    ///   - minDate: 最小日期
    ///   - maxDate: 最大日期
    ///   - mainColor: 主体颜色
    ///   - callback: 完成回调
    open static func show(type: LYAutoDateType,
                          vc: UIViewController,
                          date: Date?,
                          minDate: Date?,
                          maxDate: Date?,
                          mainColor: UIColor?,
                          callback: @escaping (Date)->Void) {
        
        let adc = LYAutoDatepickController()
        adc.type = type
        if date != nil {
            adc.date = date!
        }
        if minDate != nil {
            adc.minDate = minDate!
        }
        if maxDate != nil {
            adc.maxDate = maxDate
        }
        if mainColor != nil {
            adc.mainColor = mainColor
        }
        adc.callback = callback
        
        adc.view.backgroundColor = .clear
        adc.modalPresentationStyle = .overCurrentContext
        adc.modalTransitionStyle = .crossDissolve
        
        vc.present(adc, animated: true, completion: nil)
    }
    
}

