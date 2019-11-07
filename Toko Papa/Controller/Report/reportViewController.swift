//
//  reportViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class reportViewController: UIViewController{

    @IBOutlet weak var selectedDateButton: UIButton!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var selectedDay:Int = day
    var selectedMonth:String = String()
    var selectedYear:Int = year
    var titleText = ""
    
    override func viewWillAppear(_ animated: Bool) {
        print("appear")
        selectedDay = day
        selectedMonth = "\(months[month])"
        selectedYear = year
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
    }

    @IBAction func DateButtonClick(_ sender: Any) {
       let nextVC:calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindToReportVC(_ unwindSegue: UIStoryboardSegue) {
        guard let calendarVC = unwindSegue.source as? calendarViewController else {return}
        self.selectedDay = calendarVC.selectedDay
        self.selectedMonth = calendarVC.selectedMonth
        self.selectedYear = calendarVC.selectedYear
        self.selectedDateButton.setTitle(calendarVC.selectedDate, for: .normal)
//        print("\(selectedDay) \(selectedMonth) \(selectedYear)")
    }

}
