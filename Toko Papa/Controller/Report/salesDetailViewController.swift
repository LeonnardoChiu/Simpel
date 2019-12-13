
import UIKit
import CloudKit

class salesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var totalSalesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var totalSales = 0
    var time = ""
    
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var transactionSummary: [SummaryTransaction] = []
    
    var items = ["TV Plasma", "Home Theater Polytron", "Bluray Recorder Samsung"]
    var prices = [1500000, 1000000, 500000]
    var paymentMethod = "Cash"
    var cashierName = "Budi"
    var modelPemilik: People?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        totalSalesLabel.text = "Rp. \(totalSales)"
        timeLabel.text = time
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "LIST BARANG"
        case 1:
            return "METODE PEMBAYARAN"
        default:
            return "NAMA KASIR"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return items.count + 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "salesDetailCellID", for: indexPath) as UITableViewCell
        let itemLabel = cell.contentView.viewWithTag(1) as! UILabel
        let priceLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        switch indexPath.section {
        case 1:
            itemLabel.text = paymentMethod
            priceLabel.isHidden = true
        case 2:
            itemLabel.text = cashierName
            priceLabel.isHidden = true
        default:
            priceLabel.isHidden = false
            if indexPath.row == items.count {
               itemLabel.text = "Total"
               priceLabel.text = "Rp. \(totalSales)"
            }
            else{
                itemLabel.text = items[indexPath.row]
                priceLabel.text = "Rp. \(prices[indexPath.row])"
            }
        }
       
        
        return cell
    }
    

}
