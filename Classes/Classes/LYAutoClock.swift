//
//  LYAutoClock.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/10.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit
import SnapKit

class LYAutoClockDrawView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var start: CGPoint!
    var end: CGPoint! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        moveLinkLine()
    }
    
    fileprivate func moveLinkLine() {
        LYDatepickColor.set()
        
        let path = UIBezierPath()
        path.lineWidth = 1.0
        path.move(to: start)
        path.addLine(to: end)
        path.close()
        
        path.stroke()
        path.fill()
    }
    
}

class LYAutoBaseClock: UIView {
    
    public var currentTime: Int = 0
    public var selectBlock: ((_ :Int)->Void) = {_ in }
    
    fileprivate let clockView = UIView()
    fileprivate let clockDrawView = LYAutoClockDrawView()
    fileprivate let coverClockView = UIView()
    
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate var clocks = [UILabel]()
    
    fileprivate var canMove = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        clockView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        addSubview(clockView)
        
        clockView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(clockView.snp.width).multipliedBy(1.0)
        }
        
        addSubview(clockDrawView)
        
        clockDrawView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(clockDrawView.snp.width).multipliedBy(1.0)
        }
        
        coverClockView.backgroundColor = LYDatepickColor
        addSubview(coverClockView)
        
        coverClockView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.height.equalTo(coverClockView.snp.width).multipliedBy(1.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        clockView.layer.cornerRadius = clockView.frame.size.width / 2
        clockDrawView.layer.cornerRadius = clockDrawView.frame.size.width / 2
        coverClockView.layer.cornerRadius = coverClockView.frame.size.width / 2
        
        drawClock(clock: clockView, color: .black)
        drawClock(clock: coverClockView, color: .white)
        
        let width = clockView.frame.size.width
        let centerPoint = CALayer()
        centerPoint.frame = CGRect(x: width/2-4, y: width/2-4, width: 8, height: 8)
        centerPoint.cornerRadius = 4
        centerPoint.backgroundColor = LYDatepickColor.cgColor
        clockView.layer.addSublayer(centerPoint);
        
        drawSelectLine()
    }
    
    func drawSelectLine() {
        
    }
    
    func drawClock(clock: UIView, color: UIColor) {
        
    }
    
    final func createNewPath(x: CGFloat, y: CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: x, y: y), radius: 16, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        path.close()
        return path.cgPath
    }
    
    final override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first!
        
        if (maskLayer.path?.boundingBox.contains(touch.location(in: coverClockView)))! {
            canMove = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
}

class LYAutoHourClock: LYAutoBaseClock {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawSelectLine() {
        super.drawSelectLine()
        
        let width = clockView.frame.size.width
        
        let label = clocks[currentTime-1]
        maskLayer.path = createNewPath(x: label.center.x, y: label.center.y)
        coverClockView.layer.mask = maskLayer
        
        clockDrawView.start = CGPoint(x: width/2, y: width/2)
        clockDrawView.end = label.center
    }
    
    override func drawClock(clock: UIView, color: UIColor) {
        super.drawClock(clock: clock, color: color)
        
        let width = clock.frame.size.width
        let center = CGPoint(x: width/2, y: width/2)
        
        for i in 0...23 {
            var offsetR: CGFloat = 0
            
            if (i >= 12) {
                offsetR = 20
            } else {
                offsetR = 50
            }
            
            let angle = (Double(i) * 30 - 60) / 360 * Double.pi * 2
            let x = center.x + (width / 2 - offsetR) * CGFloat(cos(angle))
            let y = center.y + (width / 2 - offsetR) * CGFloat(sin(angle))
            
            let clockLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            clockLabel.center = CGPoint(x: x, y: y)
            clock.addSubview(clockLabel)
            
            clockLabel.textAlignment = .center
            clockLabel.textColor = color
            clockLabel.font = UIFont.systemFont(ofSize: 16)
            clockLabel.text = i == 23 ? "00" : String(i+1)
            clockLabel.tag = (i == 23 ? 0 : (i+1)) + 240
            
            if clocks.count < 24 {
                clocks.append(clockLabel)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canMove {
            let touch = touches.first!
            let newPoint = touch.location(in: coverClockView)
            
            let width = coverClockView.frame.width
            let center = CGPoint(x: width/2, y: width/2)
            
            let cord = sqrt(abs(pow((newPoint.x - center.x), 2) + pow((newPoint.y - center.y), 2)))
            let cosangle = (newPoint.x - center.x) / cord
            let sinangle = (newPoint.y - center.y) / cord
            
            var x: CGFloat = 0.0
            var y: CGFloat = 0.0
            
            if cord > width / 2 - 45 {
                x = center.x + (width / 2 - 20) * cosangle
                y = center.y + (width / 2 - 20) * sinangle
            } else {
                x = center.x + (width / 2 - 50) * cosangle
                y = center.y + (width / 2 - 50) * sinangle
            }
            
            let maskWidth = maskLayer.frame.width
            maskLayer.path = createNewPath(x: x-maskWidth/2, y: y-maskWidth/2)
            
            clockDrawView.end = CGPoint(x: x, y: y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canMove {
            let touch = touches.first!
            let newPoint = touch.location(in: coverClockView)
            
            var lessPath = 999999.0
            var lessLabel = clocks.first!
            for clockLabel in clocks {
                let path = sqrt(abs(pow((newPoint.x - clockLabel.center.x), 2) + pow((newPoint.y - clockLabel.center.y), 2)))
                if Double(path) < lessPath {
                    lessPath = Double(path)
                    lessLabel = clockLabel
                }
            }
            
            let maskWidth = maskLayer.frame.width
            maskLayer.path = createNewPath(x: lessLabel.center.x-maskWidth/2, y: lessLabel.center.y-maskWidth/2)
            
            clockDrawView.end = lessLabel.center
            
            canMove = false
            
            selectBlock(lessLabel.tag - 240)
        }
    }
}

class LYAutoMinuteClock: LYAutoBaseClock {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawSelectLine() {
        super.drawSelectLine()
        
        let width = clockView.frame.size.width
        
        let label = clocks[currentTime]
        maskLayer.path = createNewPath(x: label.center.x, y: label.center.y)
        coverClockView.layer.mask = maskLayer
        
        clockDrawView.start = CGPoint(x: width/2, y: width/2)
        clockDrawView.end = label.center
    }
    
    override func drawClock(clock: UIView, color: UIColor) {
        let width = clock.frame.size.width
        let center = CGPoint(x: width/2, y: width/2)
        
        for i in 0...59 {
            let angle = (Double(i) * 6 - 90) / 360 * Double.pi * 2
            let x = center.x + (width / 2 - 20) * CGFloat(cos(angle))
            let y = center.y + (width / 2 - 20) * CGFloat(sin(angle))
            
            let clockLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            clockLabel.center = CGPoint(x: x, y: y)
            clock.addSubview(clockLabel)
            
            clockLabel.tag = i + 600
            if i % 5 == 0 {
                clockLabel.textAlignment = .center
                clockLabel.textColor = color
                clockLabel.font = UIFont.systemFont(ofSize: 16)
                clockLabel.text = String(i)
            }
            
            if clocks.count < 60 {
                clocks.append(clockLabel)
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canMove {
            let touch = touches.first!
            let newPoint = touch.location(in: coverClockView)
            
            let width = coverClockView.frame.width
            let center = CGPoint(x: width/2, y: width/2)
            
            let cord = sqrt(abs(pow((newPoint.x - center.x), 2) + pow((newPoint.y - center.y), 2)))
            let cosangle = (newPoint.x - center.x) / cord
            let sinangle = (newPoint.y - center.y) / cord
            
            let x = center.x + (width / 2 - 20) * cosangle
            let y = center.y + (width / 2 - 20) * sinangle
            
            let maskWidth = maskLayer.frame.width
            maskLayer.path = createNewPath(x: x-maskWidth/2, y: y-maskWidth/2)
            
            clockDrawView.end = CGPoint(x: x, y: y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canMove {
            let touch = touches.first!
            let newPoint = touch.location(in: coverClockView)
            
            var lessPath = 999999.0
            var lessLabel = clocks.first!
            for clockLabel in clocks {
                let path = sqrt(abs(pow((newPoint.x - clockLabel.center.x), 2) + pow((newPoint.y - clockLabel.center.y), 2)))
                if Double(path) < lessPath {
                    lessPath = Double(path)
                    lessLabel = clockLabel
                }
            }
            
            let maskWidth = maskLayer.frame.width
            maskLayer.path = createNewPath(x: lessLabel.center.x-maskWidth/2, y: lessLabel.center.y-maskWidth/2)
            
            clockDrawView.end = lessLabel.center
            
            canMove = false
            
            selectBlock(lessLabel.tag - 600)
        }
    }
}
