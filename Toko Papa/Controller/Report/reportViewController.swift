
import UIKit
import CloudKit

class reportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
 //MARK: OUTLET
    @IBOutlet weak var selectedDateButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCollection: UICollectionView!
    
    
//MARK: VARIABLES
    var transaksi: Transaksi = Transaksi.fetchDummyData()
    var namaBarangEdit = ""
    var stockBarangEdit = 0
    var tempStringDariLogin: String = ""
    var totalSales = 0
    var highestSales = ["Sabun Molto Orange 600 ml", "Sabun Molto", "indomie goreng"]
    var highestSalesLastUpdate = ["19.15", "19.16", "19.17"]
//    var highestSalesUnit = [40, 50, 60]
//    var newItem = ["Beras C4", "Rinso Anti Noda", "Sunglight 200ml"]
//    var newItemLastUpdate = ["19.15", "18.00", "18.00"]
//    var newItemUnit = [30, 35, 30]
    var editItem = ["Beras C4", "Rinso Molto", "Piring plastik"]
    var editItemLastUpdate = ["19.15", "19.14", "19.13"]
    var editItemValue = [15000, 16000, 15000]
    var leapYearCounter = 2
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var selectedDay:Int = Int()
    var selectedMonth:String = String()
    var selectedMonthNumber = Int()
    var selectedYear:Int = Int()
    var titleText = ""
    
    var selectedEditedItem = ""
    var startWithCurrentDate = false
    var selectedIndexPath: IndexPath? = nil
    
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var modelPemilik: People?
    var barangBaru: [BarangBaru] = []
    var editBarang: [EditBarang] = []
    var inventory: [Inventory] = []
    var image: CKAsset?
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        tabBarController?.hidesBottomBarWhenPushed = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        
        print("item transaksi", transaksi)
        
        selectedDay = day
        selectedMonth = "\(months[month])"
        selectedMonthNumber = month
        selectedYear = year
        selectedIndexPath = nil
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
        monthLabel.text = "\(selectedMonth) \(year)"
        scrollTo(item: selectedDay, section: 0)
        dateCollection.reloadData()
        var mainTabBar = self.tabBarController as! MainTabBarController
            modelPemilik = mainTabBar.modelPeople
        QueryDatabase()
        print(barangBaru.count)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: true)
        print("DARI LOGIN INI BOSSSS : \(tempStringDariLogin)")
        
        //INI CALENDAR
        selectedDay = day
        selectedMonth = "\(months[month])"
        selectedMonthNumber = month
        selectedYear = year
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = IndexPath(item: selectedDay-1, section: 0)
        dateCollection.reloadData()
        startWithCurrentDate = false
        QueryDatabase()
        
        totalSales = 0
        for x in transaksi.items {
            print(x.unitSold)
            print(x.item.price)
            totalSales += (x.unitSold * x.item.price)
            print(totalSales)
        }
    }
    
    
    //MARK: - QUERYNYA
    @objc func QueryDatabase(){
       
        let tokoID = modelPemilik?.tokoID
        
        let barangBaru = CKQuery(recordType: "BarangBaru", predicate: NSPredicate(format: "tokoID == %@", tokoID!))
    
        //let sortDesc = NSSortDescriptor(key: filterString!, ascending: sorting)
        //query.sortDescriptors = [sortDesc]
        database.perform(barangBaru, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.data = record
            /// append ke model
            self.initDataModelBarangBaru()
            print("jumlah barang baru : \(self.data.count)")
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
        
        let editBarangs = CKQuery(recordType: "EditBarang", predicate: NSPredicate(format: "tokoID == %@", tokoID!))
        
            //let sortDesc = NSSortDescriptor(key: filterString!, ascending: sorting)
            //query.sortDescriptors = [sortDesc]
            database.perform(editBarangs, inZoneWith: nil) { (record, _) in
                guard let record = record else {return}
                    
                self.data = record
                /// append ke model
                self.initDataModelEditBarang()
                print("jumlah EditBarang : \(self.data.count)")
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        
        let inventory = CKQuery(recordType: "Inventory", predicate: NSPredicate(format: "TokoID == %@", tokoID!))
        
            //let sortDesc = NSSortDescriptor(key: filterString!, ascending: sorting)
            //query.sortDescriptors = [sortDesc]
            database.perform(inventory, inZoneWith: nil) { (record, _) in
                guard let record = record else {return}
                    
                self.data = record
                /// append ke model
                self.initDataModelInventory()
                print("jumlah inventory : \(self.data.count)")
                
            }
        
      }
    
    func initDataModelBarangBaru() {
        barangBaru.removeAll()
        
           print(data.count)
           for countData in data {
               let id = countData.recordID
               let namabarang = countData.value(forKey: "namaBarang") as! String
               let stock = countData.value(forKey: "Stock") as! Int
               let tokoID = countData.value(forKey: "tokoID") as! String
               let tanggal = countData.value(forKey: "Tanggal") as! Int
               let bulan = countData.value(forKey: "Bulan") as! Int
               let tahun = countData.value(forKey: "Tahun") as! Int
            
               barangBaru.append(BarangBaru(namabarang: namabarang, stock: stock, tokoid: tokoID, tanggal: tanggal, bulan: bulan, Tahun: tahun))
           }
       }
    
    func initDataModelEditBarang() {
     editBarang.removeAll()
     
        print(data.count)
        for countData in data {
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
         
            editBarang.append(EditBarang(inventoryId: inventorid, profilID: profilID, tokoID: tokoID, alasan: alasan, tanggal: tanggal, bulan: bulan, tahun: tahun, kategori: kategori, value: value))
        }
    }
    
    func initDataModelInventory() {
        inventory.removeAll()
        
        print(data.count)
        for countData in data {
            let id = countData.recordID
            let namaItem = countData.value(forKey: "NameProduct") as! String
            let stock = countData.value(forKey: "Stock") as! Int
            let price = countData.value(forKey: "Price") as! Int
            let barcode = countData.value(forKey: "Barcode") as! String
            let category = countData.value(forKey: "Category") as! String
            let distributor = countData.value(forKey: "Distributor") as! String
            let version = countData.value(forKey: "Version") as! Int
            let unit = countData.value(forKey: "Unit") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
            var itemImage: UIImage?
            image = (countData.value(forKey: "Images") as? [CKAsset])?.first
            if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
                itemImage = UIImage(data: data as Data)
                //itemImage.contentMode = .scaleAspectFill
            }
            inventory.append(Inventory(id: id, imageItem: itemImage!, namaItem: namaItem, barcode: barcode, category: category, distributor: distributor, price: price, stock: stock, version: version, unit: unit, toko: tokoID))
        }
    }
    
    
    
    
    //MARK: BUTTON ACTION
    
    @IBAction func nextButtonClick(_ sender: Any) {
//        selectedDay += 1
//        if selectedDay > daysInMonth[month] {
//            if month == 11 {
//                month = 0
//                selectedDay = 1
//                selectedMonth = months[month]
//                selectedYear += 1
//            }
//            else {
//                month += 1
//                selectedDay = daysInMonth[month]
//                selectedMonth = months[month]
//            }
//        }
        
        goToNextMonth()
        
        selectedMonth = months[month]
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = nil
        dateCollection.reloadData()
        scrollTo(item: 0, section: 0)
        
//        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
    }
    
    @IBAction func prevButtonClick(_ sender: Any) {
//        selectedDay -= 1
//        if selectedDay < 1 {
//            if month == 0 {
//                month = 11
//                selectedDay = daysInMonth[month]
//                selectedMonth = months[month]
//                selectedYear -= 1
//            }
//            else {
//                month -= 1
//                selectedDay = daysInMonth[month]
//                selectedMonth = months[month]
//            }
//        }
        goToPreviousMonth()
        
        selectedMonth = months[month]
        monthLabel.text = "\(selectedMonth) \(year)"
        selectedIndexPath = nil
        dateCollection.reloadData()
        scrollTo(item: 0, section: 0)
//        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
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

    
    //MARK: TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,1] {
            return 30
        }
        else{
            return 61
        }
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return " "
        default:
            return nil
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 30
//        }
//        else{
//            return .leastNormalMagnitude
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            if barangBaru.count == 0 {
                return 1
            }
            else if barangBaru.count > 3{
                return 4
            }
            else {
                return barangBaru.count + 1
            }
        case 3:
            if editBarang.count == 0 {
                return 1
            }
            else if editBarang.count > 3{
                return 4
            }
            else {
                return editBarang.count + 1
            }
        default:
            return 0
        }
        
     }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.tintColor = UIColor.systemBackground
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
         view.tintColor = UIColor.systemBackground
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    
    
    // MARK: - cellForRowAt
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let penjualan = tableView.dequeueReusableCell(withIdentifier: "Penjualan") as! PenjualandanPBarangBaru
        let detail = tableView.dequeueReusableCell(withIdentifier: "detailcell") as! Detail
        let total = tableView.dequeueReusableCell(withIdentifier: "total") as! TotalPenjualan
        let cells = UITableViewCell()
        penjualan.selectionStyle = .none
        penjualan.dropShadow()
        penjualan.backgroundColor = .clear
        
        detail.selectionStyle = .none
        detail.dropShadow()
        detail.backgroundColor = .clear
        
        total.selectionStyle = .none
        total.dropShadow()
        total.backgroundColor = .clear
        
        penjualan.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        total.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        detail.cellVIew.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        detail.detailButton.tag = indexPath.section
        detail.detailButton.addTarget(self, action: #selector(onClickDetailButton(_:)), for: .touchUpInside)
        
        if indexPath == [0,0] {
            total.chevron.isHidden = false
            total.TotalPenjualan.text = "Rp. \(totalSales)"
            total.cellView.frame.size.height = 57
            return total
        }
            
        if indexPath.section == 1 {
            penjualan.chevron.isHidden = true
            if indexPath.row != 3{
                penjualan.namaItem.text = "\(transaksi.items[indexPath.row].item.namaItem)"
                penjualan.unitItem.text = "Unit Terjual: \(transaksi.items[indexPath.row].unitSold)"
                penjualan.LastUpdate.text = ""
                penjualan.cellView.frame.size.height = 60
                return penjualan
            }else{
                detail.cellVIew.frame.size.height = 31
                return detail
            }
        }
        
            
        if indexPath.section == 2 {
            penjualan.chevron.isHidden = true
                if barangBaru.count == 0 {
                    total.chevron.isHidden = true
                    total.TotalPenjualan.text = "No item"
                    total.cellView.frame.size.height = 60
                    return total
                   
                }
                else if barangBaru.count > 3{
                    if indexPath.row < 3{
                        penjualan.namaItem.text = "\(barangBaru[indexPath.row].namaBarang)"
                        penjualan.unitItem.text = "Unit Masuk: \(barangBaru[indexPath.row].stock)"
                        penjualan.LastUpdate.text = ""
                        penjualan.cellView.frame.size.height = 60
                        return penjualan
                        
                        
                    }else{
                        detail.cellVIew.frame.size.height = 31
                        return detail
                    }
                   
                }
                else {
                    if indexPath.row < barangBaru.count{
                        penjualan.namaItem.text = "\(barangBaru[indexPath.row].namaBarang)"
                        penjualan.unitItem.text = "Unit Masuk: \(barangBaru[indexPath.row].stock)"
                        penjualan.LastUpdate.text = ""
                       penjualan.cellView.frame.size.height = 60
                       return penjualan
                    }else{
                        detail.cellVIew.frame.size.height = 31
                        return detail
                        
                    }
                }
            
        }
        
        if indexPath.section == 3 {
                if editBarang.count == 0 {
                    total.chevron.isHidden = true
                    total.TotalPenjualan.text = "No item"
                    total.cellView.frame.size.height = 60
                     return total
                   
                }
                else if editBarang.count > 3{
                    if indexPath.row < 3{
                        for i in inventory{
                            if editBarang[indexPath.row].inventoryID == i.Id.recordName{
                                namaBarangEdit = i.namaItem
                                stockBarangEdit = i.stock
                            }
                        }
                        
                        
                        penjualan.namaItem.text = "\(namaBarangEdit)"
                        penjualan.unitItem.text = "\(editBarang[indexPath.row].kategori): \(editBarang[indexPath.row].value)"
                        penjualan.LastUpdate.text = ""
                        penjualan.cellView.frame.size.height = 60
                        return penjualan
                    }else{
                        detail.cellVIew.frame.size.height = 31
                        return detail
                    }
                   
                }
                else {
                    
                    if indexPath.row < editBarang.count{
                        for i in inventory{
                            if editBarang[indexPath.row].inventoryID == i.Id.recordName{
                                namaBarangEdit = i.namaItem
                            }
                        }
                        penjualan.namaItem.text = "\(namaBarangEdit)"
                        penjualan.unitItem.text = "\(editBarang[indexPath.row].kategori): \(editBarang[indexPath.row].value)"
                         penjualan.LastUpdate.text = ""
                        penjualan.cellView.frame.size.height = 60
                        return penjualan
                    }else{
                        detail.cellVIew.frame.size.height = 31
                        return detail
                    }
                    
                }
            
        }
        return cells
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMonthNumber = month
        if indexPath.section == 0 {
            print(selectedMonthNumber)
            performSegue(withIdentifier: "segueToTotalSalesVC", sender: self)
        }
        else if indexPath.section == 3 {
            if indexPath.row != 3 {
                selectedEditedItem = editItem[indexPath.row]
            }
            performSegue(withIdentifier: "segueToEditItemDetails", sender: self)
        }
        
    }
    
    //MARK: COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth[selectedMonthNumber]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! ScrollCalendarCell
        
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !startWithCurrentDate {
            scrollTo(item: selectedDay-1, section: 0)
            startWithCurrentDate = true
        }
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
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = dateCollection.cellForItem(at: indexPath) as! ScrollCalendarCell
//        cell.dateLabel.textColor = UIColor.black
//        cell.Circle.isHidden = true
//    }
    
    func scrollTo(item: Int, section: Int) {
        let scrollTo = IndexPath(item: item, section: section)
        self.dateCollection.scrollToItem(at: scrollTo, at: .centeredHorizontally, animated: true)
        
    }
    
    //MARK: SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToEditItemDetails"{
            let nextVC = segue.destination as! editItemDetailViewController
            nextVC.itemName = selectedEditedItem
        }
        else if segue.identifier == "segueToTotalSalesVC" {
            let nextVC = segue.destination as! totalSalesViewController
            nextVC.selectedDay = self.selectedDay
            nextVC.selectedMonth = self.selectedMonth
            nextVC.selectedMonthNumber = self.selectedMonthNumber
            nextVC.selectedYear = self.selectedYear
        }
        else if segue.identifier == "segueToHighestSales" {
            let nextVC = segue.destination as! highestSalesViewController
            nextVC.selectedDay = self.selectedDay
            nextVC.selectedMonth = self.selectedMonth
            nextVC.selectedMonthNumber = self.selectedMonthNumber
            nextVC.selectedYear = self.selectedYear
        }
        else if segue.identifier == "segueToNewItem" {
            let nextVC = segue.destination as! newItemViewController
            nextVC.selectedDay = self.selectedDay
            nextVC.selectedMonth = self.selectedMonth
            nextVC.selectedMonthNumber = self.selectedMonthNumber
            nextVC.selectedYear = self.selectedYear
        }
        
        else if segue.identifier == "segueToEditItem" {
            let nextVC = segue.destination as! editItemViewController
            nextVC.selectedDay = self.selectedDay
            nextVC.selectedMonth = self.selectedMonth
            nextVC.selectedMonthNumber = self.selectedMonthNumber
            nextVC.selectedYear = self.selectedYear
        }
    }
    
    
    
    //MARK: IBACTION
    
    @IBAction func DateButtonClick(_ sender: Any) {
       let nextVC:calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromCalendar(_ unwindSegue: UIStoryboardSegue) {
        guard let calendarVC = unwindSegue.source as? calendarViewController else {return}
        self.selectedDay = calendarVC.selectedDay
        self.selectedMonth = calendarVC.selectedMonth
        self.selectedMonthNumber = calendarVC.selectedMonthNumber
        self.selectedYear = calendarVC.selectedYear
//        selectedIndexPath = nil
//        if selectedIndexPath != nil {
//            if IndexPath(item: selectedDay-1, section: 0).compare(selectedIndexPath!) == ComparisonResult.orderedSame {
//                selectedIndexPath = nil
//            }
//            else{
//                selectedIndexPath = IndexPath(item: selectedDay-1, section: 0)
//            }
//        }
//        else{
        self.selectedIndexPath = IndexPath(item: selectedDay-1, section: 0)
//        }
        self.selectedDateButton.setTitle(calendarVC.selectedDate, for: .normal)
        self.monthLabel.text = "\(selectedMonth) \(selectedYear)"
        startWithCurrentDate = false
        dateCollection.reloadData()
    }
    
    @objc func onClickDetailButton (_ sender: UIButton){
        let buttonSection = sender.tag
        print(buttonSection)
        switch buttonSection {
        case 1:
            performSegue(withIdentifier: "segueToHighestSales", sender: self)
        case 2:
            performSegue(withIdentifier: "segueToNewItem", sender: self)
        default:
            performSegue(withIdentifier: "segueToEditItem", sender: self)
        }
        
    }

}

//MARK: EXTENSION

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func applyConfig(for indexPath: IndexPath, numberOfCellsInSection: Int) {
        if indexPath.section == 0 {
            self.roundCorners(corners: [.topLeft, .topRight, .bottomRight, .bottomLeft], radius: 10)
        }
        else{
            switch indexPath.row {
            case numberOfCellsInSection - 1:
                // This is the case when the cell is last in the section,
                // so we round to bottom corners
                self.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)

                // However, if it's the only one, round all four
                if numberOfCellsInSection == 1 {
                    self.roundCorners(corners: [.topLeft, .topRight, .bottomRight, .bottomLeft], radius: 10)
                }

            case 0:
                // If the cell is first in the section, round the top corners
                self.roundCorners(corners: [.topRight, .topLeft], radius: 10)
            default:
                // If it's somewhere in the middle, round no corners
                self.roundCorners(corners: [.topLeft, .topRight, .bottomRight, .bottomLeft], radius: 0)
            }
        }
    }
}

extension UIView {
    func dropShadow() {
        layer.shadowColor = UIColor.label.cgColor
//        layer.shadowColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 2
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}


class PenjualandanPBarangBaru: UITableViewCell{
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var LastUpdate: UILabel!
    @IBOutlet weak var unitItem: UILabel!
    @IBOutlet weak var namaItem: UILabel!
    @IBOutlet weak var chevron: UIButton!
    override func draw(_ rect: CGRect) {
        dropShadow()
        
        super.draw(rect)
    }
}

class Detail: UITableViewCell{
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var cellVIew: UIView!
    
    override func draw(_ rect: CGRect) {
        dropShadow()
        
        super.draw(rect)
    }
}


class TotalPenjualan: UITableViewCell{
    
    
    @IBOutlet weak var chevron: UIButton!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var TotalPenjualan: UILabel!
    override func draw(_ rect: CGRect) {
        dropShadow()
        
        super.draw(rect)
    }
}

