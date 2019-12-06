//
//  CashierItemListViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class CashierItemListViewController: UIViewController {
    
    // MARK: - Variable
    var namaTemp = ""
    var priceTemp: Int = 0
    var modelPemilik: People?
    var myItem: [Inventory] = []
    var filteredItem: [Inventory] = []
    var itemCart: [Inventory] = []
    var itemTemp: Inventory?
    
    var image: CKAsset?
    var selectedItem: Inventory!
    var selectedStock: Int = 0
    var selectedPrice: Int = 0
    var index: Int = 0
    var availableStock: Int = 0
    var isOutOfStock = true
    
    var stockTemp: [Int] = []
    
    var isSearchBarEmpty: Bool {
           return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    var addAction = UIAlertAction()
    
    // MARK: - Database
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    
    // MARK: - objc untuk Query Database
    @objc func QueryDatabase(){
        let tokoID = modelPemilik?.tokoID
        let query = CKQuery(recordType: "Inventory", predicate: NSPredicate(format: "TokoID == %@", tokoID!))
       
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
              //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
            self.data = record
            /// Ambil data dari cloudkit, kemudian dimasukkan kedalam Model
            self.initDataModel()
            DispatchQueue.main.async {
                self.searchTableView.refreshControl?.endRefreshing()
                self.searchTableView.reloadData()
            }
        }
    }

    // MARK: - IBOutlet
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            searchTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var searchFooterBottomConstraint: NSLayoutConstraint!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTemp = 0
        /// buat large title di nav bar
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)]
        self.navigationController?.navigationBar.prefersLargeTitles = true
        var mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
        //self.navigationItem.setHidesBackButton(true, animated: true)
        initSearchBar()
        initNotification()
        
        let nibSearchedItem = UINib(nibName: "itemAddedCell", bundle: nil)
        searchTableView.register(nibSearchedItem, forCellReuseIdentifier: "itemAddedCell")
        
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("ITEMMM", itemCart)
        if itemCart.count != 0 {
            print("ITEMMM", itemCart[0].namaItem)
        }
        index = 0
        self.QueryDatabase()
        print("filteredddd : \(filteredItem.count)")
        print("Original :\(myItem.count)")
        DispatchQueue.main.async{
            self.searchTableView.reloadData()
        }
        
        print(myItem.count)
        for count in myItem {
            for x in itemCart {
                if count.namaItem == x.namaItem {
                    print("OTONG :", count.namaItem)
                    print("OTONG : ", x.namaItem)
                    count.stock -= x.stock
                }
            }
        }
        self.searchTableView.reloadData()
    }
    
    // MARK: - Init table model
    func initDataModel() {
        for countData in data {
            let id = countData.recordID
            let namaItem = countData.value(forKey: "NameProduct") as! String
            var stock = countData.value(forKey: "Stock") as! Int
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
            for count in itemCart {
                if namaItem == count.namaItem {
                    stock -= count.stock
                }
            }
            
            myItem.append(Inventory(id: id, imageItem: itemImage!, namaItem: namaItem, barcode: barcode, category: category, distributor: distributor, price: price, stock: stock, version: version, unit: unit, toko: tokoID))
            
            stockTemp.append(stock)
            print("Stock temp:" , stockTemp)
        }
        
        
    }
    
    // MARK: - Init Search Bar in navigation
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari produk"
        // memasukkan search bar ke navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = false
        
        //searchController.searchBar.scopeButtonTitles = ["All", "Food", "Tools", "Misc", "· · ·"]
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
    }

    // MARK: - init notification
    func initNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
        
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
    }
    
    // MARK: - handle keyboard
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            searchFooterBottomConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }
        
        guard
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else {
                return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: {() -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - init untuk buy alert
    func initAlert() {
        let addAlert = UIAlertController(title: "Tambah Jumlah", message: "Isi jumlah barang yang anda pilih", preferredStyle: .alert)
        /// add text field
        addAlert.addTextField { (textField) in
            textField.placeholder = "Masukkan jumlah barang"
            textField.keyboardType = .numberPad
            textField.delegate = self
        }
        /// add button tambah
        let addBtn = UIAlertAction(title: "Tambah", style: .default) { ACTION in
            print(self.availableStock)
            self.isOutOfStock = true
            if self.isFiltering {
                if self.selectedStock > self.availableStock {
                    print("Lebih")
                    self.isOutOfStock = true
                }
                else{
                    self.isOutOfStock = false
                }
            } else {
                if self.selectedStock > self.availableStock {
                    print("Lebih")
                    self.isOutOfStock = true
                }
                else {
                    self.isOutOfStock = false
                }
            }
            
            if !self.isOutOfStock {
                self.presentAlert(withTitle: "Sukses", message: "Barang berhasil ditambah") {
                    
                    for count in self.myItem {
                        if self.selectedItem.namaItem == count.namaItem {
                            count.stock -= self.selectedStock
                            self.itemTemp = count
                            break
                        }
                    }
                    
                    self.selectedItem.stock = self.selectedStock
                    
                    if let _ = self.presentedViewController {
                        self.presentedViewController?.dismiss(animated: false) {
                            self.performSegue(withIdentifier: "backToCashier", sender: self.selectedItem)
                        }
                    } else {
                        self.performSegue(withIdentifier: "backToCashier", sender: self.selectedItem)
                    }
                }
            }
            else{
                self.presentAlert(withTitle: "Stok tidak tersedia", message: "Barang gagal ditambah")
            }
            //self.selectedItem.qty = self.selectedStock
            
        }
        /// add button batal
        let batalBtn = UIAlertAction(title: "Batal", style: .cancel) { ACTION in
            print("cancel")
            
        }
        
        addAction = addBtn
        addAction.isEnabled = false
        
        addAlert.addAction(addAction)
        addAlert.addAction(batalBtn)
        self.present(addAlert, animated: true, completion: nil)
        
        print(addAlert.actions)
    }
    
    // MARK: - function untuk edit stock di cloudkit
    func updateStock(){
        
    }
    
    // MARK: - function untuk filtering item
    func filterContentsForSearch(_ searchText: String) {
        filteredItem = myItem.filter({ (item) -> Bool in
            return item.namaItem.lowercased().contains(searchText.lowercased())
        })
            searchTableView.reloadData()
    }
}

// MARK: - Extension table view
extension CashierItemListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredItem.count, of: myItem.count)
            return filteredItem.count
        } else {
            searchFooter.setNotFiltering()
            return myItem.count
        }
    }
    /// cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemAddedCell = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
        
        if isFiltering {
            itemAddedCell.itemNameLbl.text = filteredItem[indexPath.row].namaItem
                 itemAddedCell.priceLbl.text = "Rp. \(String(filteredItem[indexPath.row].price.commaRepresentation))"
                 itemAddedCell.quantityLbl.text = "Stock: \(String(filteredItem[indexPath.row].stock))"
                 
                 itemAddedCell.itemImage.image = filteredItem[indexPath.row].imageItem
                 itemAddedCell.itemImage.contentMode = .scaleAspectFill
                 return itemAddedCell
        } else {
            itemAddedCell.itemNameLbl.text = myItem[indexPath.row].namaItem
            itemAddedCell.priceLbl.text = "Rp. \(String(myItem[indexPath.row].price.commaRepresentation))"
            itemAddedCell.quantityLbl.text = "Stock: \(String(myItem[indexPath.row].stock))"
            
            itemAddedCell.itemImage.image = myItem[indexPath.row].imageItem
            itemAddedCell.itemImage.contentMode = .scaleAspectFill
            return itemAddedCell
        }
              
    }
    /// did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            index = indexPath.row
            print(index)
            selectedItem = filteredItem[indexPath.row]
            namaTemp = selectedItem.namaItem
            availableStock = selectedItem.stock
            print("STRTOOSAKDAODK",selectedItem.stock)
           //selectedItem.stock = selectedStock
            print("aidjasid",selectedItem.stock)
            
            print("asasas",availableStock)
            initAlert()
            //priceTemp = filteredItem[indexPath.row].price
            tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
            /// karena saat search menampilkan search view controller, jadi dismiss dahulu view si search controller
            
            //presentedViewController?.dismiss(animated: true, completion: nil)
        } else {
            index = indexPath.row
            print(index)
            selectedItem = myItem[indexPath.row]
            namaTemp = selectedItem.namaItem
            //selectedItem.stock = selectedStock
            availableStock = myItem[indexPath.row].stock
            print("sssss", availableStock)

            initAlert()
            //priceTemp = myItem[indexPath.row].price
            tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
            //performSegue(withIdentifier: "backToCashier", sender: selectedItem)
        }
         
    }
    /// prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToCashier" {
            let vc = segue.destination as! CashierViewController
            //vc.newItem = selectedItem
            var idx = 0
            var MatchItem = false
            for vcItem in vc.myItem {
                vc.stockTemp.append(vcItem)
                if vcItem.barcode == selectedItem.barcode {
                    print("KETEMU")
                    vcItem.stock += selectedItem.stock
                    vcItem.price = selectedItem.price
                    //vc.myItem.append(vcItem)
                    print(vcItem.price)
                    
                    MatchItem = true
                    break
                } else {
                    //vc.newItem = selectedItemp
                    vc.stockTemp.append(vcItem)
                    print("AAA")
                }
                
            }
            
            
            if MatchItem == false {
                vc.stockTemp.append(itemTemp!)
                vc.myItem.append(selectedItem)
            }
            
            //vc.newItem = selectedItem
            print("HARGA TOTALLLLLL : \(selectedItem.price * selectedItem.stock)")
            //vc.searchItemTotal = priceTemp * selectedStock
        }
    }
    
}

// MARK: - Extension untuk search controller delegate & results updating
extension CashierItemListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentsForSearch(searchController.searchBar.text!)
    }
    
    /// Begin editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //performSegue(withIdentifier: "toView", sender: nil)
        //searchController.obscuresBackgroundDuringPresentation = true
        //searchFooter.setNotFiltering()
    }
    
    /// End editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchFooter.showText(text: searchBar.text!)
        //searchBar.text = ""
        //print(searchBar.text)
    }
    
    /// Cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //self.navigationController?.popViewController(animated: true)
        searchBar.text = ""
        //searchTableView.reloadData()
    }
    
    /// Scope button index
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        /*selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Item.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)*/
        if searchBar.selectedScopeButtonIndex == 0 {
            print("Kolom All")
        } else if searchBar.selectedScopeButtonIndex == 1 {
            print("Kolom Food")
        } else if searchBar.selectedScopeButtonIndex == 2 {
            print("Kolom Tools")
        } else if searchBar.selectedScopeButtonIndex == 3 {
            print("Kolom ALL")
        } else if searchBar.selectedScopeButtonIndex == 4 {
            //performSegue(withIdentifier: "showFilterList", sender: nil)
            //searchBar.selectedScopeButtonIndex = 0
        }
        //print("Current scope index: \(selectedScope)")
    }

    
}

extension CashierItemListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if Int(text) != nil {
            /// text field converted to an Int
            addAction.isEnabled = true
        } else {
            /// text field is not
            addAction.isEnabled = false
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! != "" {
            selectedStock = Int(textField.text!)!
        }
        
        print(selectedStock)
    }
}
