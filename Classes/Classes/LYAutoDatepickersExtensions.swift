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

extension UIView {
    
    func top(to view: UIView,
             attribute: NSLayoutAttribute,
             constant: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: attribute,
                                            multiplier: 1.0,
                                            constant: constant)
        view.addConstraint(constraint)
    }
    
    func bottom(to view: UIView,
                attribute: NSLayoutAttribute,
                constant: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: attribute,
                                            multiplier: 1.0,
                                            constant: constant)
        view.addConstraint(constraint)
    }
    
    func left(to view: UIView,
              attribute: NSLayoutAttribute,
              constant: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: attribute,
                                            multiplier: 1.0,
                                            constant: constant)
        view.addConstraint(constraint)
    }
    
    func right(to view: UIView,
               attribute: NSLayoutAttribute,
               constant: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: attribute,
                                            multiplier: 1.0,
                                            constant: constant)
        view.addConstraint(constraint)
    }
    
    func centerX(to view: UIView,
                 attribute: NSLayoutAttribute) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: attribute,
                                            multiplier: 1.0,
                                            constant: 0.0)
        view.addConstraint(constraint)
    }
    
    func centerY(to view: UIView,
                 attribute: NSLayoutAttribute) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: attribute,
                                            multiplier: 1.0,
                                            constant: 0.0)
        view.addConstraint(constraint)
    }
    
    func width(to view: UIView,
               constant: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 0.0,
                                            constant: constant)
        view.addConstraint(constraint)
    }
    
    func height(to view: UIView,
                constant: CGFloat) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 0.0,
                                            constant: constant)
        view.addConstraint(constraint)
    }
    
    func edge(to view: UIView, padding: UIEdgeInsets) {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraintTop = NSLayoutConstraint(item: self,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: padding.top)
        let constraintBottom = NSLayoutConstraint(item: self,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: padding.bottom)
        let constraintLeft = NSLayoutConstraint(item: self,
                                                attribute: .left,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .left,
                                                multiplier: 1.0,
                                                constant: padding.left)
        let constraintRight = NSLayoutConstraint(item: self,
                                                 attribute: .right,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .right,
                                                 multiplier: 1.0,
                                                 constant: padding.right)
        
        view.addConstraints([constraintTop, constraintBottom, constraintLeft, constraintRight])
    }
    
}

