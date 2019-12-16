
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
    
    var items = ["DVD Samsung", "TV Phillips 32\" LED", "Bluray Recorder Polytron", "Mesin Cuci Samsung 10 L"]
    var values = ["price changed", "stock changed", "stock changed", "price changed"]
    var times = ["20:00", "19:33", "13:41", "09:00"]
    
    var selectedItem = ""
    var startWithCurrentDate = false
    var selectedIndexPath: IndexPath? = nil
    var leapYearCounter = 2
    
    let database = CKContainer.default().publicCloudDatabase
    var modelPemilik: People?
    var editBarang: [EditBarang] = []
    var inventory: [Inventory] = []
    var image: CKAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
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
    }
    
    //MARK: TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editItemTableCellID", for: indexPath)
        
        let itemNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let itemValue = cell.contentView.viewWithTag(3) as! UILabel
        let itemTime = cell.contentView.viewWithTag(4) as! UILabel
        
        cell.selectionStyle = .none
        
        itemNameLabel.text = items[indexPath.row]
        itemValue.text = values[indexPath.row]
        itemTime.text = times[indexPath.row]
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToDetailEditItem"{
            print("segue")
            let nextVC = segue.destination as! editItemDetailViewController
            nextVC.itemName = selectedItem
        }
    }
}
