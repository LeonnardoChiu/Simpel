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
    
    var selectedDay:Int = day
    var selectedMonth:String = ""
    var selectedYear:Int = year
    var titleText = "asd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print("\(selectedDay) \(selectedMonth) \(selectedYear)")
        let calendarVC: calendarViewController = self.storyboard?.instantiateViewController(identifier: "calendarViewController") as! calendarViewController
        print("helo")
        print(calendarVC.selectedDate)
        titleText = calendarVC.selectedDate
        
        print(titleText)
            
        if let dateButton = selectedDateButton {
            print("masuk ganti")
            dateButton.setTitle(titleText, for: .normal)
            
        }
    
//        let titleTextForce:String! = titleText
//        let theTitle = titleTextForce
//        let theButton: UIButton = selectedDateButton
//        theButton.setTitle(theTitle, for: .normal)
    
        print("\(titleText) done")
    }

    @IBAction func DateButtonClick(_ sender: Any) {
       let nextVC:calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        
        present(nextVC, animated: true, completion: nil)
    }
    
    func setButtonTitle() {
        if let dateButton = selectedDateButton {
            print("masuk")
            dateButton.setTitle(titleText, for: .normal)
        }
    }

}
