//
//  LYAutoDatepickersExtensions.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/17.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 从16进制获取UIColor
    ///
    /// - Parameters:
    ///   - hex: 16进制颜色值 ： 如 :#007ac0 即为 0x15A230
    ///   - alpha: 透明度 0 ~ 1
    /// - Returns: UIColor
    static func color(hex: Int, alpha: CGFloat) -> UIColor {
        let color = UIColor(red: CGFloat(Double(((hex & 0xFF0000) >> 16))/255.0),
                            green: CGFloat(Double(((hex & 0xFF00) >> 8))/255.0),
                            blue: CGFloat(Double((hex & 0xFF))/255.0),
                            alpha: alpha)
        
        return color
    }
    
    /// 从16进制获取UIColor alpha 默认为1
    ///
    /// - Parameter hex: 16进制颜色值 ： 如 :#007ac0 即为 0x15A230
    /// - Returns: UIColor
    static func color(hex: Int) -> UIColor {
        return UIColor.color(hex: hex, alpha: 1.0)
    }
    
}

