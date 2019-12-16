
import UIKit
import CloudKit

class editItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var selectedDateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCollection: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var selectedDay:Int = day
    var selectedMonth:String = String()
    var selectedMonthNumber = Int()
    var selectedYear:Int = year
    var titleText = ""
    
    var selectedItem = ""
    var startWithCurrentDate = false
    var selectedIndexPath: IndexPath? = nil
    var leapYearCounter = 2
    
    let database = CKContainer.default().publicCloudDatabase
    var modelPemilik: People?
    var editBarang: [EditBarang] = []
    var inventory: [Inventory] = []
    var image: CKAsset?
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
//        tableView.rowHeight = 61
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
    
    //MARK: QEURY
    
    @objc func QueryDatabase(){
        let tokoID = modelPemilik?.tokoID
        let editBarangs = CKQuery(recordType: "EditBarang", predicate: NSPredicate(format: "tokoID == %@", tokoID!))
    
        database.perform(editBarangs, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            /// append ke model
            self.initDataModelEditBarang(record: record)
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    func initDataModelEditBarang(record: [CKRecord]) {
     editBarang.removeAll()
        
        for countData in record {
            let id = countData.recordID
            let inventorid = countData.value(forKey: "InventoryID") as! String
            let profilID = countData.value(forKey: "ProfilID") as! String
            let tokoID = countData.value(forKey: "tokoID") as! String
            let alasan = countData.value(forKey: "Alasan") as! String
            let kategori = countData.value(forKey: "Kategori") as! String
            let tanggal = countData.value(forKey: "Tanggal") as! Int
            let bulan = countData.value(forKey: "Bulan") as! Int
            let tahun = countData.value(forKey: "Tahun") as! Int
            let value = countData.value(forKey: "Value") as! String
         
            if tanggal == selectedDay && bulan == month && tahun == selectedYear {
                editBarang.append(EditBarang(inventoryId: inventorid, profilID: profilID, tokoID: tokoID, alasan: alasan, tanggal: tanggal, bulan: bulan, tahun: tahun, kategori: kategori, value: value))
            }
        }
    }
    
    //MARK: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if editBarang.count == 0 {
             let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
                       noDataLabel.text = "Tidak ada barang"
                       noDataLabel.textColor = UIColor.systemRed
                       noDataLabel.textAlignment = .center
                       tableView.backgroundView = noDataLabel
                       tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            count = editBarang.count
            return editBarang.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editItemTableCellID", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let itemNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let itemValue = cell.contentView.viewWithTag(3) as! UILabel
        let itemTime = cell.contentView.viewWithTag(4) as! UILabel
        
        cell.selectionStyle = .none
        imageView.isHidden = false
        for item in inventory {
            if editBarang[indexPath.row].inventoryID == item.Id.recordName {
                itemNameLabel.text = item.namaItem
                imageView.image = item.imageItem
            }
        }
        itemValue.text = "\(editBarang[indexPath.row].kategori) : \(editBarang[indexPath.row].value)"
        itemTime.text = ""
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segueToDetailEditItem", sender: self)
    }
    
    //MARK: COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth[month]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! editItemScrollCalendarCell
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailEditItem"{
            let nextVC = segue.destination as! editItemDetailViewController
            nextVC.editBarang.removeAll()
            nextVC.editBarang.append(editBarang[selectedIndex])
            nextVC.modelPemilik = modelPemilik
            nextVC.inventory = inventory
        }
    }
}
