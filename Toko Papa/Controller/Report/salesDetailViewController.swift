
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
    var barangTerjual: [itemTransaction] = []
    var inventory: [Inventory] = []
    var image: CKAsset?
    
    var namaBarang:[String] = []
    var hargaBarang:[Int] = []
    var qty:[Int] = []
    var grandTotal = 0
    var jumlahQty = 0
    var paymentMethod = "Cash"
    var modelPemilik: People?
    
    var selectedDay:Int = Int()
    var selectedMonth:String = String()
    var selectedMonthNumber = Int()
    var selectedYear:Int = Int()
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        totalSalesLabel.text = "\(selectedDay) \(selectedMonth) \(selectedYear)"
        timeLabel.text = "Metode Pembayaran: \(transactionSummary[0].metodePembayaran)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        QueryDatabase()
        grandTotal = 0
        jumlahQty = 0
        listBarangNampil.removeAll()
        print(inventory.count)
        print(barangTerjual.count)
        
        for id in transactionSummary[0].itemID {
            for transaction in barangTerjual {
                if id == transaction.Id.recordName {
                    for item in inventory {
                        if transaction.inventoryID == item.Id.recordName {
                            listBarangNampil.append(DetailPenjualanList(namabarang: item.namaItem, qty: transaction.qty, harga: item.price))
                        }
                    }
                }
            }
        }
        
        for i in listBarangNampil{
            print(i.namaBarang)
        }
        
        tableView.reloadData()
    }
    
    var listBarangNampil: [DetailPenjualanList] = []
    
    func initBarangPenjualan(record: [CKRecord]) {
        barangTerjual.removeAll()
        for countData in record {
            let id = countData.recordID
           let inventoryID = countData.value(forKey: "InventoryID") as! String
           let qty = countData.value(forKey: "qty") as! Int
           
            
            barangTerjual.append(itemTransaction(id: id, inventoryid: inventoryID, qty: qty))
        }
        print("anjeng ; ", transactionSummary[0].itemID.count)
        print("bnsgt ; ", barangTerjual.count)
         print("babi ; ", inventory.count)
        
        
         print("ngentot ; ", listBarangNampil.count)
        for i in listBarangNampil{
            print(i.namaBarang)
        }
    }
    
    //MARK: TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "LIST BARANG"
        default:
            return "TOTAL"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ((transactionSummary.first?.itemID.count)!)
        default:
            return 1
        }
    }
    
    //MARK: CELL FOR ROW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "salesDetailCellID", for: indexPath) as UITableViewCell
        let itemLabel = cell.contentView.viewWithTag(1) as! UILabel
        let priceLabel = cell.contentView.viewWithTag(2) as! UILabel
        let qtyLabel = cell.contentView.viewWithTag(3) as! UILabel
        
        if indexPath.section == 1 {
            itemLabel.text = "Total Penjualan"
            qtyLabel.text = "Jumlah Barang: \(jumlahQty)"
            priceLabel.text = "Rp. \(grandTotal.commaRepresentation)"
        }
        else {
            itemLabel.text = listBarangNampil[indexPath.row].namaBarang
            qtyLabel.text = "x \(listBarangNampil[indexPath.row].qty)"
            priceLabel.text = "Rp. \((listBarangNampil[indexPath.row].qty * listBarangNampil[indexPath.row].harga).commaRepresentation)"
            grandTotal += (listBarangNampil[indexPath.row].qty * listBarangNampil[indexPath.row].harga)
            jumlahQty += listBarangNampil[indexPath.row].qty
        }
        
        
//        switch indexPath.section {
//        case 1:
//            itemLabel.text = paymentMethod
//            priceLabel.isHidden = true
//        case 2:
//            itemLabel.text = cashierName
//            priceLabel.isHidden = true
//        default:
//            priceLabel.isHidden = false
//            if indexPath.row == items.count {
//               itemLabel.text = "Total"
//               priceLabel.text = "Rp. \(totalSales)"
//            }
//            else{
//                itemLabel.text = items[indexPath.row]
//                priceLabel.text = "Rp. \(prices[indexPath.row].commaRepresentation)"
//            }
//        }
       
        
        return cell
    }
    

}
