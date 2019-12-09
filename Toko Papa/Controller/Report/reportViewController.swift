
import UIKit

class reportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
 //MARK: OUTLET
    @IBOutlet weak var selectedDateButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCollection: UICollectionView!
    
    
//MARK: VARIABLES
    var tempStringDariLogin: String = ""
    var totalSales = 700000
    var highestSales = ["Sabun Molto Orange 600 ml", "Sabun Molto", "indomie goreng"]
    var highestSalesLastUpdate = ["19.15", "19.16", "19.17"]
    var highestSalesUnit = [40, 50, 60]
    var newItem = ["Beras C4", "Rinso Anti Noda", "Sunglight 200ml"]
    var newItemLastUpdate = ["19.15", "18.00", "18.00"]
    var newItemUnit = [30, 35, 30]
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
    
    
//MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        tabBarController?.hidesBottomBarWhenPushed = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
        
        
        selectedDay = day
        selectedMonth = "\(months[month])"
        selectedMonthNumber = month
        selectedYear = year
        selectedIndexPath = nil
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
        monthLabel.text = "\(selectedMonth) \(year)"
        scrollTo(item: selectedDay, section: 0)
        dateCollection.reloadData()
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,1] {
            return 30
        }
        else{
            return 61
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
            return 2
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

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.tintColor = UIColor.systemBackground
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardTableCellID", for: indexPath) as! dashboardTableCell
        
        cell.selectionStyle = .none
        cell.dropShadow()
        
        cell.backgroundColor = .clear
        
        if indexPath == [0,0] {
            cell.totalSaleslabel.text = "Rp. \(totalSales)"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = false
            cell.itemLabel.isHidden = true
            cell.unitLabel.isHidden = true
            cell.updateLabel.isHidden = true
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = false
            cell.cellView.frame.size.height = 57
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [0,1] {
            cell.totalSaleslabel.text = "Rp. \(totalSales)"
            cell.cellView.isHidden = true
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = true
            cell.unitLabel.isHidden = true
            cell.updateLabel.isHidden = true
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 57
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [1,0] {
            cell.itemLabel.text = "\(highestSales[indexPath.row])"
            cell.unitLabel.text = "Unit Terjual: \(highestSalesUnit[indexPath.row])"
            cell.updateLabel.text = "\(highestSalesLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [1,1]{
            cell.itemLabel.text = "\(highestSales[indexPath.row])"
            cell.unitLabel.text = "Unit Terjual: \(highestSalesUnit[indexPath.row])"
            cell.updateLabel.text = "\(highestSalesLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [1,2]{
            cell.itemLabel.text = "\(highestSales[indexPath.row])"
            cell.unitLabel.text = "Unit Terjual: \(highestSalesUnit[indexPath.row])"
            cell.updateLabel.text = "\(highestSalesLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [2,0]{
            cell.itemLabel.text = "\(newItem[indexPath.row])"
            cell.unitLabel.text = "Unit Masuk: \(newItemUnit[indexPath.row])"
            cell.updateLabel.text = "\(newItemLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [2,1]{
            cell.itemLabel.text = "\(newItem[indexPath.row])"
            cell.unitLabel.text = "Unit Masuk: \(newItemUnit[indexPath.row])"
            cell.updateLabel.text = "\(newItemLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [2,2]{
            cell.itemLabel.text = "\(newItem[indexPath.row])"
            cell.unitLabel.text = "Unit Masuk: \(newItemUnit[indexPath.row])"
            cell.updateLabel.text = "\(newItemLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [3,0]{
            cell.itemLabel.text = "\(editItem[indexPath.row])"
            cell.unitLabel.text = "Rp. \(editItemValue[indexPath.row])"
            cell.updateLabel.text = "\(editItemLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = false
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [3,1]{
            cell.itemLabel.text = "\(editItem[indexPath.row])"
            cell.unitLabel.text = "Rp. \(editItemValue[indexPath.row])"
            cell.updateLabel.text = "\(editItemLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = false
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [3,2]{
            cell.itemLabel.text = "\(editItem[indexPath.row])"
            cell.unitLabel.text = "Rp. \(editItemValue[indexPath.row])"
            cell.updateLabel.text = "\(editItemLastUpdate[indexPath.row])"
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = false
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else {
            cell.cellView.isHidden = false
            cell.totalSaleslabel.isHidden = true
            cell.itemLabel.isHidden = true
            cell.unitLabel.isHidden = true
            cell.updateLabel.isHidden = true
            cell.detailButton.isHidden = false
            cell.chevronButton.isHidden = true
            cell.cellView.frame.size.height = 31
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
            
        }
        
        cell.detailButton.tag = indexPath.section
        cell.detailButton.addTarget(self, action: #selector(onClickDetailButton(_:)), for: .touchUpInside)
        
        return cell
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
