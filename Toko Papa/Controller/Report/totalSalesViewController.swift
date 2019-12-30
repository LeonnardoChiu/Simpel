//
//  totalSalesViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class totalSalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var dateCollection: UICollectionView!
    
    @IBOutlet weak var selectedDateButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var selectedDay:Int = Int()
    var selectedMonth:String = String()
    var selectedMonthNumber = Int()
    var selectedYear:Int = Int()
    var titleText = ""
    
    var items = [3500000, 3000000, 500000]
    var times = ["18:00", "13:00", "09:00"]
    
    var selectedItem = 0
    var selectedTime = ""
    var startWithCurrentDate = false
    var selectedIndexPath: IndexPath? = nil
    var leapYearCounter = 2
    
    let refeeshControl = UIRefreshControl()
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var modelPemilik: People?
    var transactionSummary: [SummaryTransaction] = []
    var inventory:[Inventory] = []
    var barangTerjual:[itemTransaction] = []
    var selectedIndex = 0
    
    var itemCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCount = items.count
        
        tableView.rowHeight = 61
        tableView.tableFooterView = UIView()
        
//        let prevVC = reportViewController()
//        print("\(prevVC.selectedDay) \(prevVC.selectedMonthNumber)")
//
//        selectedDay = prevVC.selectedDay
//        selectedMonth = months[prevVC.selectedMonthNumber]
//        selectedYear = prevVC.selectedYear
        selectedIndexPath = nil
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = IndexPath(item: selectedDay-1, section: 0)
        scrollTo(item: selectedDay, section: 0)
        let mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
        
        refeeshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refeeshControl.addTarget(self, action: #selector(QueryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refeeshControl
        dateCollection.reloadData()
        
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(transactionSummary.count)
        QueryDatabase()
        startWithCurrentDate = false
    }
    
    //MARK: QUERY
    @objc func QueryDatabase(){
        let tokoID = modelPemilik?.tokoID
        
        let laporan = CKQuery(recordType: "TransactionSummary", predicate: NSPredicate(format: "TokoID == %@", tokoID!))
        
         database.perform(laporan, inZoneWith: nil) { (record, _) in
             guard let record = record else {return}
                 
             /// append ke model
             self.initSummaryPenjualan(record: record)
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
            
         }
        
    }
    
    func initSummaryPenjualan(record: [CKRecord]) {
        transactionSummary.removeAll()
        for countData in record {
            let id = countData.recordID
            var itemID:[String]
            itemID = countData.value(forKey: "ItemID") as! [String]
            let tokoID = countData.value(forKey: "TokoID") as! String
            let tanggal = countData.value(forKey: "tanggal") as! Int
            let bulan = countData.value(forKey: "bulan") as! Int
            let tahun = countData.value(forKey: "tahun") as! Int
            let metodeBayar = countData.value(forKey: "MetodePembayaran") as! String
            let totalPenjualan = countData.value(forKey: "totalPenjualan") as! Int

            
            if tanggal == selectedDay && bulan == month && tahun == selectedYear {
                transactionSummary.append(SummaryTransaction(id: id, tokoID: tokoID, itemID: itemID , tanggal: tanggal, bulan: bulan, tahun: tahun, metodePembayaran: metodeBayar, totalPenjualan: totalPenjualan))

//                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if transactionSummary.count == 0 {
            return 1
        }
        else{
            return transactionSummary.count
        }
    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "salesTableCellID", for: indexPath)
        
        let sales = cell.contentView.viewWithTag(1) as! UILabel
        let time = cell.contentView.viewWithTag(2) as! UILabel
        
       
        if transactionSummary.count == 0 {
            sales.text = "No Transaction"
            time.text = ""
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        else{
            sales.text = "Rp. \(transactionSummary[indexPath.row].totalPenjualan.commaRepresentation)"
            time.text = "\(transactionSummary[indexPath.row].metodePembayaran)"
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.selectionStyle = .default
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if transactionSummary.count != 0{
//            selectedItem = items[indexPath.row]
//            selectedTime = times[indexPath.row]
//            print(selectedItem)
            selectedIndex = indexPath.row
            performSegue(withIdentifier: "segueToSalesDetailVC", sender: self)
        }
    }
    
    //MARK: COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth[month]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! totalSalesScrollCalendarCell
        
        cell.Circle.isHidden = true
        cell.dateLabel.text = "\(indexPath.row + 1)"
        
        if selectedIndexPath == indexPath {
            cell.isSelected = true
            cell.dateLabel.textColor = UIColor.white
            cell.Circle.isHidden = false
            cell.DrawCircle()
        }
        else{
            cell.isSelected = false
            cell.dateLabel.textColor = UIColor.label
            cell.Circle.isHidden = true
            
        }
        
        if selectedMonth == months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day{
            cell.dateLabel.textColor = UIColor.white
            cell.Circle.isHidden = false
            cell.DrawGreyCircle()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath != nil {
            if indexPath.compare(selectedIndexPath!) == ComparisonResult.orderedSame {
                selectedIndexPath = nil
            }
            else{
                selectedIndexPath = indexPath
            }
        }
        else{
            selectedIndexPath = indexPath
        }
        
        selectedDay = indexPath.row + 1
        selectedMonth = months[month]
        selectedYear = year
        
        dateCollection.reloadItems(at: dateCollection.indexPathsForVisibleItems)
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
        scrollTo(item: indexPath.row, section: 0)
        QueryDatabase()
        print(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !startWithCurrentDate {
            scrollTo(item: selectedDay-1, section: 0)
            startWithCurrentDate = true
        }
    }
    
    func scrollTo(item: Int, section: Int) {
        let scrollTo = IndexPath(item: item, section: section)
        self.dateCollection.scrollToItem(at: scrollTo, at: .centeredHorizontally, animated: true)
        
    }
    
    //MARK: BUTTON ACTION
    @IBAction func dateButtonClick(_ sender: Any) {
        let nextVC:calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        
        nextVC.prevVC = "Sales"
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        goToNextMonth()
        
        selectedMonth = months[month]
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = nil
        dateCollection.reloadData()
        scrollTo(item: 0, section: 0)
    }
    
    @IBAction func prevButtonClick(_ sender: Any) {
        goToPreviousMonth()
        
        selectedMonth = months[month]
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = nil
        dateCollection.reloadData()
        scrollTo(item: 0, section: 0)
    }
    
    func goToNextMonth() {
        switch selectedMonth {
        case "December":
            month = 0
            year += 1
            
            if leapYearCounter < 5 {
                leapYearCounter += 1
            }
            
            if leapYearCounter == 4 {
                daysInMonth[1] = 29
            }
            if leapYearCounter == 5{
                leapYearCounter = 1
                daysInMonth[1] = 28
            }
        default:
            month += 1
        }
    }
    
    func goToPreviousMonth() {
        switch selectedMonth {
        case "January":
            month = 11
            year -= 1
            
            if leapYearCounter > 0 {
                leapYearCounter -= 1
            }
            
            if leapYearCounter == 0 {
                daysInMonth[1] = 29
                leapYearCounter = 4
            }
            else{
                daysInMonth[1] = 29
            }
        default:
            month -= 1
        }
    }
    
    //MARK: SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSalesDetailVC"{
            print("segue")
            let nextVC = segue.destination as! salesDetailViewController
            nextVC.totalSales = selectedItem
            nextVC.time = selectedTime
            nextVC.modelPemilik = modelPemilik
            
            nextVC.transactionSummary.append(transactionSummary[selectedIndex])
            nextVC.barangTerjual = barangTerjual
            nextVC.inventory = inventory
            
            nextVC.selectedDay = selectedDay
            nextVC.selectedMonth = selectedMonth
            nextVC.selectedYear = selectedYear
        }
    }
    
    @IBAction func unwindFromCalendar(_ unwindSegue: UIStoryboardSegue) {
        guard let calendarVC = unwindSegue.source as? calendarViewController else {return}
        self.selectedDay = calendarVC.selectedDay
        self.selectedMonth = calendarVC.selectedMonth
        self.selectedMonthNumber = calendarVC.selectedMonthNumber
        self.selectedYear = calendarVC.selectedYear
        self.selectedIndexPath = IndexPath(item: selectedDay-1, section: 0)
        self.selectedDateButton.setTitle(calendarVC.selectedDate, for: .normal)
        self.monthLabel.text = "\(selectedMonth) \(selectedYear)"
        startWithCurrentDate = false
        dateCollection.reloadData()
        self.QueryDatabase()
    }
    
    
}
