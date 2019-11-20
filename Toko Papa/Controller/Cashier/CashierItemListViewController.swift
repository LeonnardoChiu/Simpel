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
    var image: CKAsset?
    var selectedItem: Item!
    
    var itemIdx = 0
    
    var isSearchBarEmpty: Bool {
           return searchController.searchBar.text?.isEmpty ?? true
       }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Database
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    
    // MARK: - objc untuk Query Database
    @objc func QueryDatabase(){
        let query = CKQuery(recordType: "Inventory", predicate: NSPredicate(value: true))
       
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
        //self.navigationItem.setHidesBackButton(true, animated: true)
        initSearchBar()
        initNotification()
        
        let nibSearchedItem = UINib(nibName: "itemAddedCell", bundle: nil)
        searchTableView.register(nibSearchedItem, forCellReuseIdentifier: "itemAddedCell")
    }
    
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.QueryDatabase()
        DispatchQueue.main.async{
            self.searchTableView.reloadData()
        }
        /*DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }*/
    }
    
    // MARK: - Init table model
    func initDataModel() {
        for countData in data {
            let namaProduk = countData.value(forKey: "NameProduct") as! String
            let stock = countData.value(forKey: "Stock") as! Int
            let price = countData.value(forKey: "Price") as! Int
            
            var itemImage: UIImage?
            image = (countData.value(forKey: "Images") as? [CKAsset])?.first
              if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
                  itemImage = UIImage(data: data as Data)
                  //itemImage.contentMode = .scaleAspectFill
              }
            
            myItem.append(Item(itemImage: itemImage!, namaProduk: namaProduk, price: price, qty: stock))

        }
    }
    
    // MARK: - Init Search Bar in navigation
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari produk"
        
        // memasukkan search bar ke navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //searchController.searchBar.scopeButtonTitles = ["All", "Food", "Tools", "Misc", "· · ·"]
        searchController.searchBar.showsSearchResultsButton = true
        self.searchController.searchBar.setImage(UIImage(systemName: "camera"), for: .resultsList, state: .normal)
    
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
    
    // MARK: - Function untuk buy alert
    func initAlert() {
        let addAlert = UIAlertController(title: "Tambah Jumlah", message: "Isi jumlah barang yang anda pilih", preferredStyle: .alert)
            
        /// Textfield
        addAlert.addTextField { (textField) in
            textField.placeholder = "Masukkan jumlah barang"
            textField.keyboardType = .numberPad
        }
        
        let add = UIAlertAction(title: "Tambah", style: .default) { ACTION in
            print(#function)
        }
        let cancel = UIAlertAction(title: "Batal", style: .cancel)
        
        addAlert.addAction(add)
        addAlert.addAction(cancel)
        self.present(addAlert, animated: true, completion: nil)
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
    func filterContentsForSearch(_ searchText: String) {
        filteredItem = myItem.filter({ (item) -> Bool in
            return item.namaProduk.lowercased().contains(searchText.lowercased())
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemAddedCell = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
        
        if isFiltering {
            itemAddedCell.itemNameLbl.text = filteredItem[indexPath.row].namaProduk
                 itemAddedCell.priceLbl.text = "Rp. \(String(filteredItem[indexPath.row].price.commaRepresentation))"
                 itemAddedCell.quantityLbl.text = "Stock: \(String(filteredItem[indexPath.row].qty))"
                 
                 itemAddedCell.itemImage.image = filteredItem[indexPath.row].itemImage
                 itemAddedCell.itemImage.contentMode = .scaleAspectFill
                 return itemAddedCell
        } else {
            itemAddedCell.itemNameLbl.text = myItem[indexPath.row].namaProduk
            itemAddedCell.priceLbl.text = "Rp. \(String(myItem[indexPath.row].price.commaRepresentation))"
            itemAddedCell.quantityLbl.text = "Stock: \(String(myItem[indexPath.row].qty))"
            
            itemAddedCell.itemImage.image = myItem[indexPath.row].itemImage
            itemAddedCell.itemImage.contentMode = .scaleAspectFill
            return itemAddedCell
        }
              
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            selectedItem = filteredItem[indexPath.row]
            //initAlert()
            tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
        } else {
            selectedItem = myItem[indexPath.row]
            //initAlert()
            tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
        }
        performSegue(withIdentifier: "backToCashier", sender: selectedItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToCashier" {
            let vc = segue.destination as! CashierViewController
            vc.newItem = selectedItem
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
        if searchBar.selectedScopeButtonIndex == 0 {
            print("Kolom All")
        } else if searchBar.selectedScopeButtonIndex == 1 {
            print("Kolom Food")
        } else if searchBar.selectedScopeButtonIndex == 2 {
            print("Kolom Tools")
        } else if searchBar.selectedScopeButtonIndex == 3 {
            print("Kolom ALL")
        }
        //print("Current scope index: \(selectedScope)")
    }
    
    /*func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let category = Item.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, category: category)
    }*/
    
}
