//
//  LYAutoClockView.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/10/23.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit

protocol LYAutoClockViewDelegate: NSObjectProtocol {
    func changeClock(time: Int, type: LYAutoClockMoveType)
    func changeMoveType(type: LYAutoClockMoveType)
}

enum LYAutoClockMoveType {
    case hour
    case minute
}

class LYAutoClockView: UIView {
    
    fileprivate weak var delegate: LYAutoClockViewDelegate?
    
    var date: Date! {
        didSet {
            let type = moveType
            moveType = type
        }
    }
    fileprivate var minDate: Date!
    fileprivate var maxDate: Date!
    fileprivate var mainColor: UIColor!
    
    fileprivate var width: CGFloat!
    
    fileprivate var hourPts = [CGPoint]()
    fileprivate var minutePts = [CGPoint]()
    fileprivate var hourLabels = [UILabel]()
    fileprivate var minuteLabels = [UILabel]()
    
    fileprivate var bgClockView: UIView!
    
    fileprivate let timeMask = CAShapeLayer()
    fileprivate let timeLabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 20, height: 20)))
    
    var moveType: LYAutoClockMoveType = .hour {
        didSet {
            switch moveType {
            case .hour:
                let minTime = getTimeRange(type: 1)
                let maxTime = getTimeRange(type: 2)
                
                for (i, label) in hourLabels.enumerated() {
                    if i >= minTime && i <= maxTime {
                        label.textColor = UIColor.color(hex: 0x333333)
                    } else {
                        label.textColor = UIColor.color(hex: 0xcccccc)
                    }
                    
                    bgClockView.addSubview(label)
                }
                for label in minuteLabels {
                    label.removeFromSuperview()
                }
                break
            case .minute:
                let minTime = getTimeRange(type: 3)
                let maxTime = getTimeRange(type: 4)
                
                for label in hourLabels {
                    label.removeFromSuperview()
                }
                for (i, label) in minuteLabels.enumerated() {
                    if i % 5 == 0 {
                        if i >= minTime && i <= maxTime {
                            label.textColor = UIColor.color(hex: 0x333333)
                        } else {
                            label.textColor = UIColor.color(hex: 0xcccccc)
                        }
                    } else {
                        if i >= minTime && i <= maxTime {
                            label.backgroundColor = UIColor.color(hex: 0x333333)
                        } else {
                            label.backgroundColor = UIColor.color(hex: 0xcccccc)
                        }
                    }
                    
                    bgClockView.addSubview(label)
                }
                break
            }
            
            createNewPath()
        }
    }
    fileprivate var isCanMove: Bool = false
    
    init(frame: CGRect,
         delegate: LYAutoClockViewDelegate,
         date: Date,
         minDate: Date,
         maxDate: Date,
         mainColor: UIColor) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        self.delegate = delegate
        self.minDate = minDate
        self.maxDate = maxDate
        self.mainColor = mainColor
        
        width = bounds.width * 0.9
        
        createViews()
        
        self.date = date
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createViews() {
        bgClockView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        bgClockView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        bgClockView.backgroundColor = UIColor.color(hex: 0xe6e6e6)
        bgClockView.layer.cornerRadius = width / 2
        addSubview(bgClockView)
        
        drawClock()
        
        timeMask.fillColor = UIColor.clear.cgColor
        timeMask.strokeColor = mainColor.cgColor
        timeMask.lineWidth = 20.0
        timeMask.lineCap = kCALineCapRound
        bgClockView.layer.addSublayer(timeMask)
        
        timeLabel.textAlignment = .center
        timeLabel.backgroundColor = mainColor
        timeLabel.textColor = .white
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.layer.masksToBounds = true
        timeLabel.layer.cornerRadius = 10.0
        timeLabel.layer.borderColor = UIColor.white.cgColor
        timeLabel.layer.borderWidth = 1.0
        bgClockView.addSubview(timeLabel)
    }
    
    fileprivate func drawClock() {
        for i in 0...23 {
            let angle = (Double(i) * 15 - 90) / 360 * Double.pi * 2
            let x = width / 2 + (width / 2 - 40) * CGFloat(cos(angle))
            let y = width / 2 + (width / 2 - 40) * CGFloat(sin(angle))
            
            hourPts.append(CGPoint(x: x, y: y))
            
            let labelAngle = (Double(i) * 15 - 90) / 360 * Double.pi * 2
            let labelX = width / 2 + (width / 2 - 15) * CGFloat(cos(labelAngle))
            let labelY = width / 2 + (width / 2 - 15) * CGFloat(sin(labelAngle))
            
            let hourLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            hourLabel.center = CGPoint(x: labelX, y: labelY)
            hourLabel.textAlignment = .center
            hourLabel.font = UIFont.systemFont(ofSize: 12)
            hourLabel.text = String(i)
            hourLabels.append(hourLabel)
        }
        
        for i in 0...59 {
            let angle = (Double(i) * 6 - 90) / 360 * Double.pi * 2
            let x = width / 2 + (width / 2 - 40) * CGFloat(cos(angle))
            let y = width / 2 + (width / 2 - 40) * CGFloat(sin(angle))
            
            minutePts.append(CGPoint(x: x, y: y))
            
            let labelAngle = (Double(i) * 6 - 90) / 360 * Double.pi * 2
            let labelX = width / 2 + (width / 2 - 15) * CGFloat(cos(labelAngle))
            let labelY = width / 2 + (width / 2 - 15) * CGFloat(sin(labelAngle))
            
            if i % 5 == 0 {
                let minuteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
                minuteLabel.center = CGPoint(x: labelX, y: labelY)
                minuteLabel.textAlignment = .center
                minuteLabel.font = UIFont.systemFont(ofSize: 12)
                minuteLabel.text = String(i)
                minuteLabels.append(minuteLabel)
            } else {
                let minuteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 2, height: 2))
                minuteLabel.center = CGPoint(x: labelX, y: labelY)
                minuteLabel.layer.cornerRadius = 1
                minuteLabel.layer.masksToBounds = true
                minuteLabels.append(minuteLabel)
            }
        }
    }
    
    fileprivate func createNewPath() {
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        
        var sPt: CGPoint!
        var ePt: CGPoint!
        var time: Int!
        
        if moveType == .hour {
            let minTime = getTimeRange(type: 1)
            let maxTime = getTimeRange(type: 2)
            if dateComponents.hour! >= minTime && dateComponents.hour! <= maxTime {
                time = dateComponents.hour!
            } else {
                time = minTime
            }
            sPt = hourPts[0]
            ePt = hourPts[time]
        } else {
            let minTime = getTimeRange(type: 3)
            let maxTime = getTimeRange(type: 4)
            if dateComponents.minute! >= minTime && dateComponents.minute! <= maxTime {
                time = dateComponents.minute!
            } else {
                time = minTime
            }
            sPt = minutePts[0]
            ePt = minutePts[time]
        }
        
        timeLabel.text = String(time)
        timeLabel.center = ePt
        
        let center = CGPoint(x: width/2, y: width/2)
        let distance = getDistance(sPt: center, ePt: sPt)
        let angle = getAngle(cPt: center, aPt: sPt, bPt: ePt)
        timeMask.path = UIBezierPath(arcCenter: center,
                                     radius: distance,
                                     startAngle: -CGFloat(Double.pi/2),
                                     endAngle: angle-CGFloat(Double.pi/2),
                                     clockwise: true).cgPath
    }
    
    //MARK: - touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        if !isCanMove {
            let touch = touches.first!
            
            if timeLabel.frame.contains(touch.location(in: bgClockView)) {
                isCanMove = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isCanMove {
            let touch = touches.first!
            let newPoint = touch.location(in: bgClockView)
            
            var times: [CGPoint]!
            var minTime: Int!
            var maxTime: Int!
            switch(moveType) {
            case .hour:
                times = hourPts
                minTime = getTimeRange(type: 1)
                maxTime = getTimeRange(type: 2)
                break
            case .minute:
                times = minutePts
                minTime = getTimeRange(type: 3)
                maxTime = getTimeRange(type: 4)
                break
            }
            
            var min: CGFloat = 9999
            var index = 0
            for i in minTime...maxTime {
                let pt = times[i]
                let distance = getDistance(sPt: pt, ePt: newPoint)
                if distance < min {
                    min = distance
                    index = i
                }
            }
            
            delegate?.changeClock(time: index, type: moveType)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isCanMove && moveType == .hour {
            moveType = .minute
            delegate?.changeMoveType(type: moveType)
        }
        
        isCanMove = false
    }
    
    //MARK: - Method
    fileprivate func getAngle(cPt: CGPoint, aPt: CGPoint, bPt: CGPoint) -> CGFloat {
        let x1 = aPt.x - cPt.x
        let y1 = aPt.y - cPt.y
        let x2 = bPt.x - cPt.x
        let y2 = bPt.y - cPt.y
        
        let x = x1 * x2 + y1 * y2
        let y = x1 * y2 - x2 * y1
        
        var angle = acos(x / CGFloat(sqrt(Double(x*x+y*y))))
        
        if bPt.x < cPt.x {
            angle = CGFloat(Double.pi) * 2 - angle
        }
        
        return angle
    }
    
    fileprivate func getDistance(sPt: CGPoint, ePt: CGPoint) -> CGFloat {
        let distanceX = Double(sPt.x) - Double(ePt.x)
        let distanceY = Double(sPt.y) - Double(ePt.y)
        return CGFloat(sqrt(distanceX * distanceX + distanceY * distanceY))
    }
    
    /// 获取最小或最大 时 分
    ///
    /// - Parameter type: 1：最小时钟；2：最大时钟；3：最小分钟；4：最大分钟。
    /// - Returns: 数值
    fileprivate func getTimeRange(type: Int) -> Int {
        let minComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: minDate)
        let maxComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: maxDate)
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        
        switch type {
        case 1:
            if dateComponent.year == minComponent.year &&
                dateComponent.month == minComponent.month &&
                dateComponent.day == minComponent.day {
                return minComponent.hour!
            }
            return 0
        case 2:
            if dateComponent.year == maxComponent.year &&
                dateComponent.month == maxComponent.month &&
                dateComponent.day == maxComponent.day {
                return maxComponent.hour!
            }
            return 23
        case 3:
            if dateComponent.year == minComponent.year &&
                dateComponent.month == minComponent.month &&
                dateComponent.day == minComponent.day &&
                dateComponent.hour == minComponent.hour {
                return minComponent.minute!
            }
            return 0
        case 4:
            if dateComponent.year == maxComponent.year &&
                dateComponent.month == maxComponent.month &&
                dateComponent.day == maxComponent.day &&
                dateComponent.hour == maxComponent.hour {
                return maxComponent.minute!
            }
            return 59
        default:
            return 0
        }
    }
    
}
