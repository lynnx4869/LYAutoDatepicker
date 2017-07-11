//
//  LYAutoDatepickers.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

public enum LYAutoDateType {
    case YMD
    case HmS
    case YMDHmS
}

//FF9000
var LYDatepickColor = UIColor(red: 1.0, green: 0.5674, blue: 0.0, alpha: 1.0)

public struct LYAutoDatepickers {
    
    public static func showDatepicker(type: LYAutoDateType,
                                      vc: UIViewController,
                                      date: Date?,
                                      minDate: Date?,
                                      maxDate: Date?,
                                      block:@escaping (_ : Date)->Void) {
        
        var apbc: LYAutoPickBaseController!
        
        if type == .YMD || type == .YMDHmS {
            apbc = LYAutoDatepickController(nibName: "LYAutoDatepickController", bundle: Bundle.main)
        } else {
            apbc = LYAutoTimepickController(nibName: "LYAutoTimepickController", bundle: Bundle.main)
        }
        
        apbc.type = type
        if date != nil {
            apbc.date = date!
        }
        if minDate != nil {
            apbc.minDate = minDate
        }
        if maxDate != nil {
            apbc.maxDate = maxDate
        }
        apbc.block = block
        apbc.presentVc = vc

        apbc.view.backgroundColor = .clear
        apbc.modalPresentationStyle = .overCurrentContext
        apbc.modalTransitionStyle = .crossDissolve
        
        vc.present(apbc, animated: true, completion: nil)
    }
    
}

