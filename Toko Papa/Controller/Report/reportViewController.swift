//
//  reportViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class reportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
 
    @IBOutlet weak var selectedDateButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var totalSales = 700000
    var highestSales = ["Sabun Molto Orange 600 ml", "Sabun Molto ", "600 ml"]
    var highestSalesLastUpdate = ["19.15", "19.15", "19.15"]
    var highestSalesUnit = [40, 50, 60]
    var newItem = ["DVD Player", "DVD Player", "DVD Player"]
    var newItemLastUpdate = ["19.15", "19.15", "19.15"]
    var newItemUnit = [30, 35, 30]
    var editItem = ["Gelas", "Piring", "Kaca"]
    var editItemLastUpdate = ["19.15", "19.15", "19.15"]
    var editItemValue = [15000, 16000, 15000]
    
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //ambil data cloudkit
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Total Penjualan"
        case 1:
            return "Penjualan Terbanyak"
        case 2:
            return "Barang Baru"
        default:
            return "Barang Terakhir Diedit"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 4
        case 3:
            return 4
        default:
            return 0
        }
        
        
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardTableCellID", for: indexPath)
        
        let itemLabel = cell.contentView.viewWithTag(1) as! UILabel
        let unitLabel = cell.contentView.viewWithTag(2) as! UILabel
        let updateLabel = cell.contentView.viewWithTag(3) as! UILabel
        let detailButton = cell.contentView.viewWithTag(4) as! UIButton

        detailButton.isHidden = true
        self.tableView.rowHeight = 61
        
        if indexPath == [0,0] {
            itemLabel.text = "Rp. \(totalSales)"
            unitLabel.isHidden = true
            updateLabel.isHidden = true
        }
        else if indexPath == [1,0] {
            itemLabel.text = "\(highestSales[indexPath.row])"
            unitLabel.text = "Unit Terjual: \(highestSalesUnit[indexPath.row])"
        }
        else if indexPath == [1,1]{
            itemLabel.text = "\(highestSales[indexPath.row])"
            unitLabel.text = "Unit Terjual: \(highestSalesUnit[indexPath.row])"
        }
        else if indexPath == [1,2]{
            itemLabel.text = "\(highestSales[indexPath.row])"
            unitLabel.text = "Unit Terjual: \(highestSalesUnit[indexPath.row])"
        }
        else if indexPath == [1,3]{
            self.tableView.rowHeight = 35
            itemLabel.isHidden = true
            unitLabel.isHidden = true
            updateLabel.isHidden = true
            detailButton.isHidden = false
        }
        else if indexPath == [2,0]{
            itemLabel.text = "\(newItem[indexPath.row])"
            unitLabel.text = "Unit Masuk: \(newItemUnit[indexPath.row])"
        }
        else if indexPath == [2,1]{
            itemLabel.text = "\(newItem[indexPath.row])"
            unitLabel.text = "Unit Masuk: \(newItemUnit[indexPath.row])"
        }
        else if indexPath == [2,2]{
            itemLabel.text = "\(newItem[indexPath.row])"
            unitLabel.text = "Unit Masuk: \(newItemUnit[indexPath.row])"
        }
        else if indexPath == [2,3]{
            self.tableView.rowHeight = 35
            itemLabel.isHidden = true
            unitLabel.isHidden = true
            updateLabel.isHidden = true
            detailButton.isHidden = false
        }
        else if indexPath == [3,0]{
            itemLabel.text = "\(editItem[indexPath.row])"
            unitLabel.text = "Rp. \(editItemValue[indexPath.row])"
        }
        else if indexPath == [3,1]{
            itemLabel.text = "\(editItem[indexPath.row])"
            unitLabel.text = "Rp. \(editItemValue[indexPath.row])"
        }
        else if indexPath == [3,2]{
            print("masuk")
            print(editItem[indexPath.row])
            itemLabel.text = "\(editItem[indexPath.row])"
            unitLabel.text = "Rp. \(editItemValue[indexPath.row])"
        }
        else if indexPath == [3,3]{
            self.tableView.rowHeight = 35
//            itemLabel.isHidden = true
//            unitLabel.isHidden = true
//            updateLabel.isHidden = true
            detailButton.isHidden = false
        }
        
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
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
