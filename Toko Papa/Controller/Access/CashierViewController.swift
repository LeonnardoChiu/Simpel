//
//  CashierViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class CashierViewController: UIViewController {
    
    // MARK: - Variable
    var itemTemp: [Inventory] = []
    var stockTemp: [Inventory] = []
    var stock = 0
    var idTransaksi: [String] = []
    var idRef: CKRecord.ID?
    var pembayaran = "Tunai"
    
    var myItem: [Inventory] = []
    var newItem: Inventory?
    var modelPemilik: People?
    var priceTemp: [Int] = []
    var totalPrice: Int = 0
    var searchItemTotal: Int = 0
    var GrandTotal:Int = 0
    var barcode: QRData?
    var barcodeTemp = ""
    var items: [Inventory] = []
    var getScanItem = false
    var getSearchItem = false

    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Database
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var image: CKAsset?
    
    // MARK: - IBOutlet
    @IBOutlet weak var cashierTableView: UITableView! {
        didSet{
            cashierTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var finishBtnOutlet: UIBarButtonItem!
    @IBAction func finishBtn(_ sender: Any) {
       
        let alert = UIAlertController(title: "Sukses", message: "Transaksi berhasil", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.updateToCloud()
            self.createDetailTransaction()
            self.createTransactionSummary()
            self.idTransaksi.removeAll()
            self.items.removeAll()
            self.myItem.removeAll()
            self.searchItemTotal = 0
            self.totalPrice = 0
            self.cashierTableView.reloadData()
            self.finishBtnOutlet.isEnabled = false
        }
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        // MARK: - add xib pakai UINib
        let nibItem = UINib(nibName: "CashierCell", bundle: nil)
        cashierTableView.register(nibItem, forCellReuseIdentifier: "CashierCell")
        
        let nibItemAdded = UINib(nibName: "itemAddedCell", bundle: nil)
        cashierTableView.register(nibItemAdded, forCellReuseIdentifier: "itemAddedCell")
        
        let nibPaymentMethod = UINib(nibName: "PaymentMethodCell", bundle: nil)
        cashierTableView.register(nibPaymentMethod, forCellReuseIdentifier: "PaymentMethodCell")
        
        let nibTotalPrice = UINib(nibName: "TotalPriceCell", bundle: nil)
        cashierTableView.register(nibTotalPrice, forCellReuseIdentifier: "TotalPriceCell")
        
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        itemTemp.removeAll()
        let mainTabBar = self.tabBarController as! MainTabBarController
        
        modelPemilik = mainTabBar.modelPeople
        //QueryDatabase()
        //print(data.first)
        //GrandTotal = 0
        if myItem.count != 0 {
            //print("ID : ", stockTemp[0].Id.recordName)
            //print("ID :", stockTemp.count)
            //print("ID STOCK : ", stockTemp[0].stock)
            //print(stockTemp)
            finishBtnOutlet.isEnabled = true
        } else {
            finishBtnOutlet.isEnabled = false
        }
        
        if newItem != nil {
            GrandTotal += (newItem!.price * newItem!.stock)
            print(GrandTotal)
            
            myItem.append(newItem!)
            //searchItemTotal += newItem!.price
            for item in myItem {
                searchItemTotal += item.price
            }
            
            newItem = nil
            searchItemTotal = 0
        }
           
        print("Total Price: \(totalPrice)")
        print("Total Price dari search item: \(searchItemTotal)")
        
        DispatchQueue.main.async{
            self.cashierTableView.reloadData()
        }
        
        self.QueryDatabase()
        if getScanItem == true {
            for item in items {
                if barcode?.codeString == item.barcode {
                    
                    if myItem.count == 0 {
                        item.stock = 1
                        totalPrice = item.price * item.stock
                        myItem.append(item)
                    }
                    else{
                        
                        var MatchItem = false
                        for index in myItem {
                            if item.barcode == index.barcode {
                                index.stock += 1
                                MatchItem = true
                                break
                            }
                            else{
                                MatchItem = false
                            }
                        }
                        
                        if MatchItem == false {
                            item.stock = 1
                            totalPrice = item.price * item.stock
                            myItem.append(item)
                        }
                        print(item.barcode)
                        print(item.namaItem)
                    }
                    GrandTotal += totalPrice
                }
            }
            totalPrice = 0
            self.cashierTableView.reloadData()
            getScanItem = false
        }
        
        if data.count != 0 {
            print(data.count)
            print(data)
        }
        if myItem.count != 0 {
            print(myItem[0].Id.recordName)
        }
        
    }
    
    // MARK: - Search Bar in navigation
    func initSearchBar() {
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Cari produk"
        searchController.searchBar.showsSearchResultsButton = true
        searchController.searchBar.setImage(UIImage(systemName: "camera.fill"), for: .resultsList, state: .normal)
        // memasukkan search bar ke navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.searchBar.delegate = self
    }
    
    // MARK: - Update barang ke cloud setelah pembayaran
    func updateToCloud() {
        var inventory: CKRecord?
        var updateStock: Int = 0
        //updateStock()
        for dataCount in data {
               updateStock = 0
                for myCart in myItem {
                    print(dataCount.recordID.recordName)
                    print(myCart.Id.recordName)
                    if  dataCount.recordID.recordName == myCart.Id.recordName {
                        inventory = dataCount
                        updateStock = inventory!.value(forKey: "Stock") as! Int
                        let tempStock = updateStock - myCart.stock
                        print("ID STOCK MY CART : ", myCart.stock)
                        inventory?.setValue(tempStock, forKey: "Stock")
                        database.save(inventory!) { (record, error) in
                            guard record != nil else { return}
                            print("Updateeeee")
                        }
                    }
                    
                    
                }
            
            print(dataCount.value(forKey: "NameProduct")!)
            
            
        }
       
        
    }
    
    // MARK: - Masukkin data penjualan ke history / invoice
    func createDetailTransaction() {
        
        print(myItem.count)
            for item in myItem{
                let itemTransaksi = CKRecord(recordType: "ItemTransaction")
                print(itemTransaksi)
                itemTransaksi.setValue(item.Id.recordName, forKeyPath: "InventoryID")
                itemTransaksi.setValue(item.stock, forKeyPath: "qty")
                idTransaksi.append(itemTransaksi.recordID.recordName)
                
                database.save(itemTransaksi) { (record, error) in
//                    self.idRef = itemTransaksi.recordID
                    guard record != nil else { return }

                
                print("ID si transaksi", itemTransaksi.recordID.recordName)
                }
                
            }
        
    }
    
    //MARK: - Summary Transaction
    func createTransactionSummary() {
        let transactionSummary = CKRecord(recordType: "TransactionSummary")
        print(transactionSummary)
        //let itemTransaksi = CKRecord(recordType: "itemTransaksi")
        transactionSummary.setValue(day, forKeyPath: "tanggal")
        transactionSummary.setValue(month, forKeyPath: "bulan")
        transactionSummary.setValue(year, forKeyPath: "tahun")
        transactionSummary.setValue(pembayaran, forKeyPath: "MetodePembayaran")
        transactionSummary.setValue(modelPemilik?.tokoID, forKeyPath: "TokoID")
        transactionSummary.setValue(self.idTransaksi, forKey: "ItemID")
        transactionSummary.setValue(GrandTotal, forKey: "totalPenjualan")
        
    
        database.save(transactionSummary) { (record, error) in
            guard record != nil else { return }
        }
    }
    
    // MARK: - Unwind list
    /// unwind dari search page
    @IBAction func unwindFromItemSearch(_ unwindSegue: UIStoryboardSegue) {
        guard let _ = unwindSegue.source as? CashierItemListViewController else { return }
        // Use data from the view controller which initiated the unwind segue
        getSearchItem = true
        
    }
    
    /// unwind dari barcode scan page
    @IBAction func unwindFromBarcodeScanner(_ unwindSegue: UIStoryboardSegue) {
        guard let BarcodeScanVC = unwindSegue.source as? BarcodeScannerController else { return }
        self.barcode = BarcodeScanVC.qrData
        self.barcodeTemp = "\(barcode?.codeString ?? "")"
        print(barcodeTemp)
        getScanItem = true
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSearchView" {
            if myItem.count != 0 {
                guard let searchVC = segue.destination as? CashierItemListViewController else { return }
                for count in myItem {
                    searchVC.itemCart.append(count)
                }
            }
        }
    }
    
}

// MARK: - EXTENSION
extension CashierViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = 0
        
        switch section {
        case 0:
            if myItem.count == 0 {
                row = 1
            } else {
                row = myItem.count + 1
            }
            
            break
        case 1:
            //row = cash.count
            row = 2
            break
        default:
            break
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if myItem.count == 0 {
                /// kosong barang
                return 188
            } else if indexPath.row < myItem.count {
                /// ada barang
                return 75
            }
        }
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// validasi checkmark di cell payment
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                /// cell 0 section 1 -> tunai
                tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.accessoryType = .checkmark
                tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))?.accessoryType = .none
                pembayaran = "Tunai"
            } else {
                /// cell 1 section 1 -> non tunai
                tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.accessoryType = .none
                tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))?.accessoryType = .checkmark
                pembayaran = "Non tunai"
            }
            //performSegue(withIdentifier: "toPaymentMethod", sender: nil)
            
        }
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "List Barang"
        default:
            return "Metode Pembayaran"
        }
    }
    // MARK: - cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            GrandTotal = 0
        }
        
        if myItem.count == 0 && indexPath.section == 0 {
            // MARK: - Nampilin cell jika barang belum ada
            let noItemCell = tableView.dequeueReusableCell(withIdentifier: "CashierCell") as! CashierCell
            
            return noItemCell
        } else if indexPath.row == myItem.count && indexPath.section == 0 {
           // MARK: - Nampilin cell Total
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "TotalPriceCell") as! TotalPriceCell
           
            
            print("Grand TOTAL: \(GrandTotal)")
            print("Total price: \(totalPrice)")
            totalCell.priceNumericLbl.text = "Rp. \(GrandTotal.commaRepresentation)"
         
            return totalCell
        } else if myItem.count != 0 && indexPath.section == 0 {
            // MARK: - Nampilin cell barang yang dipilih
            let itemAddedCell = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
            itemAddedCell.itemNameLbl.text = myItem[indexPath.row].namaItem
            itemAddedCell.priceLbl.text = "Rp. \(myItem[indexPath.row].price.commaRepresentation)"
            itemAddedCell.quantityLbl.text = "Quantity: \(String(myItem[indexPath.row].stock))"
            
            itemAddedCell.itemImage.image = myItem[indexPath.row].imageItem
            itemAddedCell.itemImage.contentMode = .scaleAspectFill
            
            //totalPrice = myItem[indexPath.row].price * myItem[indexPath.row].stock
            //print("Total dari cell for row at \(totalPrice)")
            GrandTotal += myItem[indexPath.row].price * myItem[indexPath.row].stock
            itemTemp.append(myItem[indexPath.row])
            
            return itemAddedCell
        }
        
        /// Check total harga keseluruhan
     
        if indexPath.section == 1 {
            // MARK: - nampilin cell payment method
            let paymentMethodCell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as! PaymentMethodCell
            
            if indexPath.row == 0 && indexPath.section == 1 {
                paymentMethodCell.cashLbl.text = "Tunai"
                paymentMethodCell.accessoryType = .checkmark
            } else if indexPath.row == 1 && indexPath.section == 1 {
                paymentMethodCell.cashLbl.text = "Non tunai"
                paymentMethodCell.accessoryType = .none
            }
            
            
            return paymentMethodCell
        }
        
        return UITableViewCell()
    }
    
//MARK: QUERY DATABASE
    @objc func QueryDatabase(){
       
        let tokoID = modelPemilik?.tokoID
        let query = CKQuery(recordType: "Inventory", predicate: NSPredicate(format: "TokoID == %@", tokoID!))
    
        //let sortDesc = NSSortDescriptor(key: filterString!, ascending: sorting)
        //query.sortDescriptors = [sortDesc]
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.data = record
            /// append ke model
            self.initDataModel()
            print("jumlah barang : \(self.data.count)")
//            DispatchQueue.main.async {
//                self.tableView.refreshControl?.endRefreshing()
//                self.tableView.reloadData()
//            }
        }
    }
    
    // MARK: - init data model
    func initDataModel() {
        items.removeAll()
        print("---")
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
            items.append(Inventory(id: id, imageItem: itemImage!, namaItem: namaItem, barcode: barcode, category: category, distributor: distributor, price: price, stock: stock, version: version, unit: unit, toko: tokoID))
        }
    }
    
}

// MARK: - Extension untuk search controller
extension CashierViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "toSearchView", sender: nil)
    }
    
    /// kalo button search di keyboard ditekan
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //performSegue(withIdentifier: "toSearchView", sender: nil)
    }
    
    /// untuk barcode button dalam search bar
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        print("To Barcode Scanner")
        performSegue(withIdentifier: "toBarcodeScanner", sender: nil)
    }
}
