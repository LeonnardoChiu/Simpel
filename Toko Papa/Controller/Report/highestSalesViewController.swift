//
//  highestSalesViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 14/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class highestSalesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    var items = ["DVD Samsung", "TV Phillips 32\" LED", "Bluray Recorder Polytron", "Mesin Cuci Samsung 10 L"]
    var units = [50, 10, 42, 21]
    
    var startWithCurrentDate = false
    var selectedIndexPath: IndexPath? = nil
    var leapYearCounter = 2
    
    var namaBarangPenjualan: [String] = []
    var qtyBarangPenjualan: [Int] = []
    var BarangPenjualan:[(nama: String, qty: Int)] = []
    
    let database = CKContainer.default().publicCloudDatabase
    var modelPemilik: People?
    var inventory: [Inventory] = []
    var barangTerjual: [itemTransaction] = []
    var transactionSummary: [SummaryTransaction] = []
    var image: CKAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 61
        tableView.tableFooterView = UIView()
        
        selectedIndexPath = nil
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = IndexPath(item: selectedDay-1, section: 0)
        scrollTo(item: selectedDay, section: 0)
        dateCollection.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startWithCurrentDate = false
        QueryDatabase()
    }
    
    
    //MARK: - QUERYNYA
    @objc func QueryDatabase(){
       
        let tokoID = modelPemilik?.tokoID
        
        let laporan = CKQuery(recordType: "TransactionSummary", predicate: NSPredicate(format: "TokoID == %@", tokoID!))
        
         database.perform(laporan, inZoneWith: nil) { (record, _) in
             guard let record = record else {return}
             print(laporan)
             /// append ke model
             self.initSummaryPenjualan(record: record)
             
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
             
         }
         
         let itemTransaksi = CKQuery(recordType: "ItemTransaction", predicate: NSPredicate(value: true))
         database.perform(itemTransaksi, inZoneWith: nil) { (record, _) in
             guard let record = record else {return}
                 
             /// append ke model
             self.initBarangPenjualan(record: record)
            
             DispatchQueue.main.async {
                 self.tableView.refreshControl?.endRefreshing()
                 self.tableView.reloadData()
             }
         }
    }
    
    func initBarangPenjualan(record: [CKRecord]) {
        barangTerjual.removeAll()
        for countData in record {
            let id = countData.recordID
           let inventoryID = countData.value(forKey: "InventoryID") as! String
           let qty = countData.value(forKey: "qty") as! Int
           
            
            barangTerjual.append(itemTransaction(id: id, inventoryid: inventoryID, qty: qty))
        }
    }
    
    func initSummaryPenjualan(record: [CKRecord]) {
        transactionSummary.removeAll()
        for countData in record {
            let id = countData.recordID
            var itemID:[String]?
            itemID = countData.value(forKey: "ItemID") as? [String]
            let tokoID = countData.value(forKey: "TokoID") as! String
            let tanggal = countData.value(forKey: "tanggal") as! Int
            let bulan = countData.value(forKey: "bulan") as! Int
            let tahun = countData.value(forKey: "tahun") as! Int
            let metodeBayar = countData.value(forKey: "MetodePembayaran") as! String
            let totalPenjualan = countData.value(forKey: "totalPenjualan") as! Int

            
            if tanggal == selectedDay && bulan == month && tahun == selectedYear {
                transactionSummary.append(SummaryTransaction(id: id, tokoID: tokoID, itemID: itemID ?? [], tanggal: tanggal, bulan: bulan, tahun: tahun, metodePembayaran: metodeBayar, totalPenjualan: totalPenjualan))
                
            }
        }
    }
    
    func getPenjualan() {
        namaBarangPenjualan.removeAll()
        qtyBarangPenjualan.removeAll()
        for transaction in transactionSummary {
            var barangBaru = false
            for id in transaction.itemID {
                for detail in barangTerjual {
                    if id == detail.Id.recordName {
                        for item in inventory {
                            if detail.inventoryID == item.Id.recordName {
                                if namaBarangPenjualan.count != 0 {
                                    var index = 0
                                    for barang in namaBarangPenjualan {
                                        if barang == item.namaItem {
                                            print("NAMBAH: ", item.namaItem)
                                            print("SEBELUM: ", qtyBarangPenjualan[index])
                                            qtyBarangPenjualan[index] += detail.qty
                                            print("SESUDAH: ", qtyBarangPenjualan[index])
                                            barangBaru = false
                                            break
                                           }
                                           else{
                                            barangBaru = true
                                        }
                                        index += 1
                                    }
                                    if barangBaru == true {
                                        namaBarangPenjualan.append(item.namaItem)
                                        qtyBarangPenjualan.append(detail.qty)
                                        print("BARU ", item.namaItem)
                                        break
                                    }
                                }
                                else{
                                    namaBarangPenjualan.append(item.namaItem)
                                    qtyBarangPenjualan.append(detail.qty)
                                    print("BARU ", item.namaItem)
                                    print("QTY: ", detail.qty)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        print(namaBarangPenjualan)
        print(qtyBarangPenjualan)
        BarangPenjualan = Array(zip(namaBarangPenjualan, qtyBarangPenjualan))
        BarangPenjualan = BarangPenjualan.sorted(by: {$0.qty > $1.qty})
        print(BarangPenjualan.sorted(by: {$0.qty > $1.qty}))

    }
    
    //MARK: TABLEVIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getPenjualan()
        var count = 0
        if BarangPenjualan.count == 0 {
             let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
                       noDataLabel.text = "Tidak ada barang"
                       noDataLabel.textColor = UIColor.systemRed
                       noDataLabel.textAlignment = .center
                       tableView.backgroundView = noDataLabel
                       tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            count = BarangPenjualan.count
            return BarangPenjualan.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highestSalesTableCellID", for: indexPath)
        let itemImage = cell.contentView.viewWithTag(1) as! UIImageView
        let itemNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let itemUnitLabel = cell.contentView.viewWithTag(3) as! UILabel
        
        cell.selectionStyle = .none
        
        for item in inventory {
            if BarangPenjualan[indexPath.row].nama == item.namaItem {
                itemImage.image = item.imageItem
            }
        }
        
        itemNameLabel.text = BarangPenjualan[indexPath.row].nama
        itemUnitLabel.text = "\(BarangPenjualan[indexPath.row].qty) Unit Terjual"
        
        return cell
    }
    
    //MARK: COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth[month]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! highestSalesScrollCalendarCell
        
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
        print(indexPath)
        QueryDatabase()
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
    
    @IBAction func prevButtonClick(_ sender: Any) {
        goToPreviousMonth()
        
        selectedMonth = months[month]
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = nil
        dateCollection.reloadData()
        scrollTo(item: 0, section: 0)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        goToNextMonth()
        
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
