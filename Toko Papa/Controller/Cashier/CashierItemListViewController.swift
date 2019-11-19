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
    var myItem: [Item] = []
    var filteredItem: [Item] = []
    var itemFilter: [String]!
    var originalItem: [String]!
    var count = 5
    
    var image: CKAsset?
    var filterString: String = "NameProduct"
    var sorting = false
    var namaItemTemp: String = ""
    var priceTemp: Int = 0
    var stockTemp: Int = 0
    
    var produk1 = Item(namaProduk: "Indomie", price: 5000, qty: 12)
    var produk2 = Item(namaProduk: "Chitato", price: 12000, qty: 32)
    var produk3 = Item(namaProduk: "Ultra Milk", price: 16000, qty: 22)
    
    var item: [String] = ["Indomie kari", "Helm", "Tolak angin", "Kolor", "Apple", "Samsung", "Gula", "Micin"]
    var price: [Int] = [5000, 50000, 4600, 7400, 12000, 90000, 2200, 5000]
    var qty: [Int] = [3, 5, 21, 11, 6, 2, 1, 8]
    
    // MARK: - Database
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var filteredData = [CKRecord]()
    
    // MARK: - objc untuk Query Database
    @objc func QueryDatabase(){
        let query = CKQuery(recordType: "Inventory", predicate: NSPredicate(value: true))
       
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
              //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
            self.data = record
            DispatchQueue.main.async {
                self.searchTableView.refreshControl?.endRefreshing()
                self.searchTableView.reloadData()
            }
        }
    }
    
    var items: [String] = []
    var prices: [Int] = []
    var qtys: [Int] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    let searchController = UISearchController(searchResultsController: nil)

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
        DispatchQueue.main.async{
            self.searchTableView.reloadData()
        }
        myItem.append(produk1)
        myItem.append(produk2)
        myItem.append(produk3)
        //self.navigationItem.setHidesBackButton(true, animated: true)
        initSearchBar()
        initNotification()
        
        let nibSearchedItem = UINib(nibName: "itemAddedCell", bundle: nil)
        searchTableView.register(nibSearchedItem, forCellReuseIdentifier: "itemAddedCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.QueryDatabase()
        /*DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }*/
    }
    
    // MARK: - Init Search Bar in navigation
    func initSearchBar() {
        //searchController.searchResultsUpdater = self
        //searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari produk"
        
        // memasukkan search bar ke navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["All", "Food", "Tools", "Misc"]
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
    }

    // MARK: - function untuk notification
    func initNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
        
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
            self.handleKeyboard(notification: notification)
        }
    }
    
    // MARK: - function untuk handle keyboard
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
    
    // MARK: - function untuk filtering item
    /*func filterContentForSearchText(_ searchText: String, category: Item.Category? = nil) {
        filteredItems = myItems.filter{ (item: Item) -> Bool in
            let doesCategoryMatch = category == .All || item.category == category
            
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && item.name.lowercased().contains(searchText.lowercased())
            }
        }
        searchTableView.reloadData()
    }*/
    
}

//extension CashierItemListViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchbar = searchController.searchBar
//        //let category = Item.Category(rawValue: searchbar.scopeButtonTitles![searchbar.selectedScopeButtonIndex])
//        //filterContentForSearchText(searchbar.text!, category: category)
//
//    }
//}

// MARK: - Extension text field
//extension CashierItemListViewController: UISearchTextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let subStrings = (textField.text! as NSString).replacingCharacters(in: range, with: string)
//
//    }
//}

// MARK: - Extension table view
extension CashierItemListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive == true && searchController.searchBar.text != "" {
            return filteredData.count
        }
        //return item.count
        //return myItem.count
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemAddedCell = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
        
//        itemAddedCell.itemNameLbl.text = item[indexPath.row]
//        itemAddedCell.priceLbl.text = "\(String(price[indexPath.row])),00"
//        itemAddedCell.quantityLbl.text = String(qty[indexPath.row])
        let namaProduk = data[indexPath.row].value(forKey: "NameProduct") as! String
        let stock = data[indexPath.row].value(forKey: "Stock") as! Int
        let price = data[indexPath.row].value(forKey: "Price") as! Int
      
        image = (data[indexPath.row].value(forKey: "Images") as? [CKAsset])?.first
        if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
            itemAddedCell.itemImage.image = UIImage(data: data as Data)
            itemAddedCell.itemImage.contentMode = .scaleAspectFill
        }
        
        itemAddedCell.itemNameLbl.text = namaProduk
        let stringPrice = price.commaRepresentation
        itemAddedCell.priceLbl.text = "Rp. \(stringPrice)"
        itemAddedCell.quantityLbl.text = "Stock left: \(String(stock))"
        
        if searchController.isActive == true && searchController.searchBar.text != "" {
            itemAddedCell.itemNameLbl.text = filteredData[indexPath.row].value(forKey: "NameProduct") as? String
            itemAddedCell.priceLbl.text = "\(filteredData[indexPath.row].value(forKey: "Price") as! Int),00"
            itemAddedCell.quantityLbl.text = "\(filteredData[indexPath.row].value(forKey: "Stock") as! Int)"
            
            if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
                itemAddedCell.itemImage.image = UIImage(data: data as Data)
                itemAddedCell.itemImage.contentMode = .scaleAspectFill
            }
//            itemAddedCell.itemNameLbl.text = itemFilter[indexPath.row]
//            itemAddedCell.priceLbl.text = "\(String(price[indexPath.row])),00"
//            itemAddedCell.quantityLbl.text = String(qty[indexPath.row])
            
            return itemAddedCell
        }
        
        return itemAddedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let searchedItem = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
        
        /*if searchController.isActive == true && searchController.searchBar.text != "" {
            print(String(searchedItem.itemNameLbl.text!))
        }*/
        
        performSegue(withIdentifier: "backToCashier", sender: nil)
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
        
    }
    
    
    
}

// MARK: - Extension search bar
extension CashierItemListViewController: UISearchBarDelegate {
    
    /// Begin editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Start edit")
        //performSegue(withIdentifier: "toView", sender: nil)
        searchController.obscuresBackgroundDuringPresentation = true
        searchFooter.setIsFilteringToShow(filteredItemCount: 5, of: 11)
        //searchFooter.setNotFiltering()
    }
    
    /// End editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("End edit")
        
        searchFooter.showText(text: searchBar.text!)
        //print(searchBar.text)
    }
    
    /// Cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
        //searchBar.text = ""
        //searchTableView.reloadData()
    }
    
    /// Text did change in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchController.searchBar.text
        itemFilter = item.filter({ (item) -> Bool in
            let value: NSString = item as NSString
            return (value.range(of: searchString!, options: .caseInsensitive).location != NSNotFound)
        })
        searchTableView.reloadData()
    }
    
    /// Scope button index change
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        if searchBar.selectedScopeButtonIndex == 0 {
            print("All")
        }
    }
    
    /*func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Item.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }*/
    
}
