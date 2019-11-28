//
//  calendarViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 06/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class calendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var calendarView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let daysOfMonth = ["Monday", "Tuessday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    var currentMonth = String()
    var currentDate = Int()
    var numberOfEmptyBox = Int() // the number of "empty boxes" at the start of the current month
    var nextNumberOfEmptyBox = Int() // the same with above but with the next month
    var prevNumberOfEmptyBox = 0 // the same with above with the prev month
    var direction = 0 // =0 if we are at the current month, = -1 if we are in a future month, =-1 if we are in past month
    var positionIndex = 0 // here we will store the above vers of the empty boxes
    var leapYearCounter = 2 //its 2 because the next time february has 29 days
    var dayCounter = 0
    var selectedDate = ""
    
    var selectedDay = Int()
    var selectedMonth = String()
    var selectedMonthNumber = Int()
    var selectedYear = Int()
    
    var prevVC = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("did load")
        selectedMonthNumber = month
        currentMonth = months[month]
        
        monthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        getStartDateDayPosition()
        
    }
    
    func getStartDateDayPosition(){
        switch direction {
        case 0:
        numberOfEmptyBox = weekday
        dayCounter = day
        while dayCounter > 0 {
            numberOfEmptyBox = numberOfEmptyBox - 1
            dayCounter = dayCounter - 1
            if numberOfEmptyBox == 0 {
                numberOfEmptyBox = 7
            }
            
        }
        
        if numberOfEmptyBox == 7 {
            numberOfEmptyBox = 0
        }
        positionIndex = numberOfEmptyBox
            
        case 1...:
            nextNumberOfEmptyBox = (positionIndex + daysInMonth[month])%7
            positionIndex = nextNumberOfEmptyBox
            print("NEXT")
            
        case -1:
            prevNumberOfEmptyBox = (7 - (daysInMonth[month] - positionIndex)%7)
            if prevNumberOfEmptyBox == 7 {
                prevNumberOfEmptyBox = 0
            }
            positionIndex = prevNumberOfEmptyBox
            print("PREV")
            
        default:
            fatalError()
        }
        print(positionIndex)
        print(currentMonth)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        switch currentMonth {
        case "December":
            direction = 1
            month = 0
            year += 1
            
            if leapYearCounter < 5 {
                leapYearCounter += 1
            }
            if leapYearCounter == 4{
                daysInMonth[1] = 29
            }
            if leapYearCounter == 5{
                leapYearCounter = 1
                daysInMonth[1] = 28
            }
            
            getStartDateDayPosition()
            
        default:
            direction = 1
            getStartDateDayPosition()
            month += 1
        }
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        calendarView.reloadData()
    }
    
    @IBAction func prevButton(_ sender: Any) {
        switch currentMonth {
        case "January":
            direction = -1
            month = 11
            year -= 1
            
            if leapYearCounter > 0 {
                leapYearCounter -= 1
            }
            if leapYearCounter == 0{
                daysInMonth[1] = 29
                leapYearCounter = 4
            }
            else {
                daysInMonth[1] = 28
            }
            
            getStartDateDayPosition()
            
        default:
            direction = -1
            month -= 1
            getStartDateDayPosition()
        }
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        calendarView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch direction {
        case 0:
            return daysInMonth[month] + numberOfEmptyBox
        case 1...:
            return daysInMonth[month] + nextNumberOfEmptyBox
        case -1:
            return daysInMonth[month] + prevNumberOfEmptyBox
        default:
            fatalError()
        }
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.dateLabel.textColor = UIColor.black
        cell.Circle.isHidden = true
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - prevNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLabel.text!)! < 1{
            cell.isHidden = true
        }
        
        switch indexPath.row {
        case 5,12,19,26,33: //weekend day warnanya abu"
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.blue
            }
        case 6,13,20,27,34:
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.red
            }
        default:
            break
        }
        
        //mark grey the cell of the current date
        if currentMonth == months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 - numberOfEmptyBox == day{
            cell.dateLabel.textColor = UIColor.white
            cell.Circle.isHidden = false
            cell.DrawGreyCircle()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        let selectedDay = Int(selectedCell.dateLabel!.text!)!
//        let selectedMonth = months[month]
//        let selectedYear = year
        selectedCell.dateLabel.textColor = UIColor.white
        selectedCell.Circle.isHidden = false
        selectedCell.DrawCircle()
        
        self.selectedDate = "\(selectedDay) \(months[month]) \(year)"
        self.selectedDay = Int(selectedCell.dateLabel!.text!)!
        self.selectedMonth = months[month]
        self.selectedMonthNumber = month
        self.selectedYear = year
        
        performSegue(withIdentifier: "goBackFromCalendar", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        
        cell.dateLabel.textColor = UIColor.black
        cell.Circle.isHidden = true
    }

}
