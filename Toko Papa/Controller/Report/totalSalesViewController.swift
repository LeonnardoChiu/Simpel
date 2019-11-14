//
//  totalSalesViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class totalSalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var selectedDateButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var selectedDay:Int = day
    var selectedMonth:String = String()
    var selectedYear:Int = year
    var titleText = ""
    
    var items = [3500000, 3000000, 500000]
    var times = ["18:00", "13:00", "09:00"]
    
    var selectedItem = 0
    var selectedTime = ""
    
    var itemCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCount = items.count
        
        tableView.tableFooterView = UIView()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return itemCount
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "salesTableCellID", for: indexPath)
        
        let sales = cell.contentView.viewWithTag(1) as! UILabel
        let time = cell.contentView.viewWithTag(2) as! UILabel
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        sales.text = "\(items[indexPath.row])"
        time.text = "\(times[indexPath.row])"
        
        return cell
      }
      
    
    @IBAction func dateButtonClick(_ sender: Any) {
        let nextVC:calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        
        nextVC.prevVC = "Sales"
        present(nextVC, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedItem = items[indexPath.row]
        selectedTime = times[indexPath.row]
        print(selectedItem)
        
        performSegue(withIdentifier: "segueToSalesDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSalesDetailVC"{
            print("segue")
            let nextVC = segue.destination as! salesDetailViewController
            nextVC.totalSales = selectedItem
            nextVC.time = selectedTime
        }
    }
    
    @IBAction func unwindFromCalendar(_ unwindSegue: UIStoryboardSegue) {
        guard let calendarVC = unwindSegue.source as? calendarViewController else {return}
        self.selectedDay = calendarVC.selectedDay
        self.selectedMonth = calendarVC.selectedMonth
        self.selectedYear = calendarVC.selectedYear
        self.selectedDateButton.setTitle(calendarVC.selectedDate, for: .normal)
    }
    
    
}
