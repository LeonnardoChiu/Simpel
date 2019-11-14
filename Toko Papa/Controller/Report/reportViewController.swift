
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
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var selectedDay:Int = day
    var selectedMonth:String = String()
    var selectedYear:Int = year
    var titleText = ""
    
    var selectedEditedItem = ""
    
    override func viewDidLoad() {
        selectedDay = day
        selectedMonth = "\(months[month])"
        selectedYear = year
        selectedDateButton.setTitle("\(selectedDay) \(selectedMonth) \(selectedYear)", for: .normal)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 100
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
        return 61
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

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboardTableCellID", for: indexPath) as! dashboardTableCell
        
        cell.selectionStyle = .none
        cell.dropShadow()
        
        cell.backgroundColor = .clear
        
        if indexPath == [0,0] {
            cell.itemLabel.text = "Rp. \(totalSales)"
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = true
            cell.updateLabel.isHidden = true
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = false
            cell.cellView.frame.size.height = 57
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else if indexPath == [1,0] {
            cell.itemLabel.text = "\(highestSales[indexPath.row])"
            cell.unitLabel.text = "Unit Terjual: \(highestSalesUnit[indexPath.row])"
            cell.updateLabel.text = "\(highestSalesLastUpdate[indexPath.row])"
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
            cell.itemLabel.isHidden = false
            cell.unitLabel.isHidden = false
            cell.updateLabel.isHidden = false
            cell.detailButton.isHidden = true
            cell.chevronButton.isHidden = false
            cell.cellView.frame.size.height = 61
            cell.cellView.applyConfig(for: indexPath, numberOfCellsInSection: tableView.numberOfRows(inSection: indexPath.section))
        }
        else {
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
        print(indexPath)
        
        if indexPath.section == 0 {
            performSegue(withIdentifier: "segueToTotalSalesVC", sender: self)
        }
        else if indexPath.section == 3{
            if indexPath.row < 3 {
                selectedEditedItem = editItem[indexPath.row]
                performSegue(withIdentifier: "segueToEditItemDetails", sender: self)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToEditItemDetails"{
            print("segue")
            let nextVC = segue.destination as! editItemDetailViewController
            nextVC.itemName = selectedEditedItem
        }
    }
    
    @IBAction func DateButtonClick(_ sender: Any) {
       let nextVC:calendarViewController = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        
        present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromCalendar(_ unwindSegue: UIStoryboardSegue) {
        guard let calendarVC = unwindSegue.source as? calendarViewController else {return}
        self.selectedDay = calendarVC.selectedDay
        self.selectedMonth = calendarVC.selectedMonth
        self.selectedYear = calendarVC.selectedYear
        self.selectedDateButton.setTitle(calendarVC.selectedDate, for: .normal)
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

extension UIView {
    func dropShadow() {
      layer.shadowColor = UIColor.black.cgColor
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
