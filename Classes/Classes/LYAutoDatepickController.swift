//
//  LYAutoDatepickController.swift
//  LYAutoDatepickers
//
//  Created by xianing on 2017/7/7.
//  Copyright © 2017年 lyning. All rights reserved.
//

import UIKit
import SwiftDate

class LYAutoDatepickController: LYAutoPickBaseController, UITableViewDelegate, UITableViewDataSource, LYAutoCalendarDelegate {
    
    @IBOutlet fileprivate weak var yearLabel: UILabel!
    @IBOutlet fileprivate weak var monthLabel: UILabel!
    @IBOutlet fileprivate weak var dayLabel: UILabel!
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    fileprivate var isYear: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "LYAutoYearCell", bundle: .main), forCellReuseIdentifier: "LYAutoYearCellId")
        tableView.register(UINib(nibName: "LYAutoCalendarCell", bundle: .main), forCellReuseIdentifier: "LYAutoCalendarCellId")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeYear))
        yearLabel.addGestureRecognizer(tap)
        
        setDisplayDate(date: date)
        
        minDate = getMinMonth()
        maxDate = getMaxMonth()
        
        tableView.scrollToRow(at: IndexPath(row: 3, section: 0), at: .bottom, animated: false)
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { 
            self.numOfYears = (self.maxDate! - self.minDate!).in(.year)! + 1
            self.numOfMonths = (self.maxDate! - self.minDate!).in(.month)! + 1
            
            self.isLoaded = true
            
            let index = (self.date! - self.minDate!).in(.month)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: index!, section: 0), at: .bottom, animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("LY Auto Date Picker dealloc ...")
    }
    
    //MARK: - Events
    @IBAction fileprivate func clickToCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func clickToSure(_ sender: Any) {
        if type == .YMD {
            block(date)
            dismiss(animated: true, completion: nil)
        }
        
        if type == .YMDHmS {
            let atpc = LYAutoTimepickController(nibName: "LYAutoTimepickController", bundle: Bundle.main)

            atpc.type = type
            if date != nil {
                atpc.date = date!
            }
            if minDate != nil {
                atpc.minDate = minDate
            }
            if maxDate != nil {
                atpc.maxDate = maxDate
            }
            atpc.block = block
            atpc.presentVc = presentVc
                        
            atpc.view.backgroundColor = .clear
            atpc.modalPresentationStyle = .overCurrentContext
            atpc.modalTransitionStyle = .crossDissolve
            
            dismiss(animated: false, completion: {
                self.presentVc?.present(atpc, animated: false, completion: nil)
            })
        }
    }
    
    @objc fileprivate func changeYear() {
        if !isYear {
            isYear = true
            
            if minDate != nil && maxDate != nil {
                tableView.reloadData()
                tableView.scrollToRow(at: IndexPath(row: date.year-(minDate?.year)!, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    fileprivate func setDisplayDate(date: Date) {
        self.date = date
        
        yearLabel.text = String(date.year)
        monthLabel.text = String(date.month) + "月"
        dayLabel.text = String(date.day)
    }
    
    fileprivate func getMinMonth() -> Date {
        if minDate != nil {
            if date - 100.years > minDate! {
                return date - 100.years
            } else {
                return minDate!
            }
        } else {
            return date - 100.years
        }
    }
    
    fileprivate func getMaxMonth() -> Date {
        if maxDate != nil {
            if date + 100.years < maxDate! {
                return date + 100.years
            } else {
                return maxDate!
            }
        } else {
            return date + 100.years
        }
    }
    
    fileprivate var isLoaded: Bool = false
    fileprivate var numOfMonths: Int!
    fileprivate var numOfYears: Int!
    
    //MARK: - UITableViewDelegate
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoaded {
            if isYear {
                return numOfYears
            } else {
                return numOfMonths
            }
        } else {
            return 7
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isYear {
            return 90
        } else {
            if isLoaded {
                let currentMonth = (minDate! + indexPath.row.months).getFirstDay()
                let daysInMonth = currentMonth.weekday - 1 + currentMonth.monthDays
                let weeks: Int = daysInMonth / 7 + (daysInMonth % 7 > 0 ? 1 : 0)
                
                return CGFloat(60 + weeks * 30)
            } else {
                let currentMonth = (date + (indexPath.row - 3).months).getFirstDay()
                let daysInMonth = currentMonth.weekday - 1 + currentMonth.monthDays
                let weeks: Int = daysInMonth / 7 + (daysInMonth % 7 > 0 ? 1 : 0)
                
                return CGFloat(60 + weeks * 30)
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoaded {
            if isYear {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LYAutoYearCellId", for: indexPath) as! LYAutoYearCell
                
                let curYear = (minDate?.year)! + indexPath.row
                cell.year = String(curYear)
                cell.isSelect = curYear == date.year
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LYAutoCalendarCellId", for: indexPath) as! LYAutoCalendarCell
                cell.delegate = self
    
                cell.date = date
                cell.minDate = minDate
                cell.maxDate = maxDate
                
                cell.currentMonth = (minDate! + indexPath.row.months).getFirstDay()
                
                return cell
            }
        } else {
            if isYear {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LYAutoYearCellId", for: indexPath) as! LYAutoYearCell
                
                let curYear = date.year + (indexPath.row - 3)
                cell.year = String(curYear)
                cell.isSelect = curYear == date.year
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LYAutoCalendarCellId", for: indexPath) as! LYAutoCalendarCell
                cell.delegate = self
                
                cell.date = date
                cell.minDate = minDate
                cell.maxDate = maxDate
                
                cell.currentMonth = (date + (indexPath.row-3).months).getFirstDay()
                
                return cell
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isYear {
            let curYear = (minDate?.year)! + indexPath.row
            let formatStr = "\(curYear)-\(date.month)-\(date.day) \(date.hour):\(date.minute):\(date.second)"
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
            setDisplayDate(date: format.date(from: formatStr)!)
            
            isYear = false
            tableView.reloadData()
            
            let index = (date - minDate!).in(.month)
            self.tableView.scrollToRow(at: IndexPath(row: index!, section: 0), at: .bottom, animated: false)
        }
    }
    
    //MARK: - LYAutoCalendarDelegate
    internal func getSelectDay(date: Date) {
        setDisplayDate(date: date)
        tableView.reloadData()
    }

}
