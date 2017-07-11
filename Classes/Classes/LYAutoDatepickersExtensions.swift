//
//  LYAutoDatepickersExtensions.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

extension Date {
    
    func getFirstDay() -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateStr = String(self.year) + "-" + String(self.month) + "-01 00:00:00"
        let newDate = format.date(from: dateStr)!
        return newDate
    }
    
}
