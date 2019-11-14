//
//  highestSalesViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 14/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class highestSalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var selectedDateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var selectedDay:Int = day
    var selectedMonth:String = String()
    var selectedYear:Int = year
    var titleText = ""
    
    var items = ["DVD Samsung", "TV Phillips 32\" LED", "Bluray Recorder Polytron", "Mesin Cuci Samsung 10 L"]
    var units = [50, 10, 42, 21]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 61
        tableView.tableFooterView = UIView()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highestSalesTableCellID", for: indexPath)
//        let itemImage = cell.contentView.viewWithTag(1) as! UIImageView
        let itemNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let itemUnitLabel = cell.contentView.viewWithTag(3) as! UILabel
        
        cell.selectionStyle = .none
        
        itemNameLabel.text = items[indexPath.row]
        itemUnitLabel.text = "\(units[indexPath.row]) Unit Masuk"
        
        return cell
    }
    
    
    
    @IBAction func dateButtonClick(_ sender: Any) {
        let nextVC:calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        
        nextVC.prevVC = "Sales"
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func prevButtonClick(_ sender: Any) {
        selectedDay -= 1
        if selectedDay < 1 {
            if month == 0 {
                month = 11
                selectedDay = daysInMonth[month]
                selectedMonth = months[month]
                selectedYear -= 1
            }
            else {
                month -= 1
                selectedDay = daysInMonth[month]
                selectedMonth = months[month]
            }
        }
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        selectedDay += 1
        if selectedDay > daysInMonth[month] {
            if month == 11 {
                month = 0
                selectedDay = 1
                selectedMonth = months[month]
                selectedYear += 1
            }
            else {
                month += 1
                selectedDay = daysInMonth[month]
                selectedMonth = months[month]
            }
        }
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
    }
    
    @IBAction func unwindFromCalendar(_ unwindSegue: UIStoryboardSegue) {
        guard let calendarVC = unwindSegue.source as? calendarViewController else {return}
        self.selectedDay = calendarVC.selectedDay
        self.selectedMonth = calendarVC.selectedMonth
        self.selectedYear = calendarVC.selectedYear
        self.selectedDateButton.setTitle(calendarVC.selectedDate, for: .normal)
    }
    

}
