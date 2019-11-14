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
    var myItems: [Item] = []
    var filteredItems: [Item] = []
    var itemFilter: [String] = []
    var count = 5
    
    var item: [String] = ["Indomie kari", "Helm", "Tolak angin", "Kolor"]
    var price: [Int] = [5000, 50000, 4600, 7400]
    var qty: [Int] = [3, 5, 21, 11]
    
    // MARK: - Database
    let database = CKContainer.default().publicCloudDatabase
    var data: CKRecord?
    
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
        self.navigationItem.setHidesBackButton(true, animated: true)
        initSearchBar()
        initNotification()
        
        let nibItemAdded = UINib(nibName: "itemAddedCell", bundle: nil)
        searchTableView.register(nibItemAdded, forCellReuseIdentifier: "itemAddedCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }*/
    }
    
    // MARK: - Search Bar in navigation
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Cari produk"
        
        // memasukkan search bar ke navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["All", "Food", "Tools", "Misc"]
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

extension CashierItemListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchbar = searchController.searchBar
        
        
        //let category = Item.Category(rawValue: searchbar.scopeButtonTitles![searchbar.selectedScopeButtonIndex])
        //filterContentForSearchText(searchbar.text!, category: category)
        
    }
}

// MARK: - Extension table view
extension CashierItemListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemAddedCell = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
        
        itemAddedCell.itemNameLbl.text = item[indexPath.row]
        itemAddedCell.priceLbl.text = "\(String(price[indexPath.row])),00"
        itemAddedCell.quantityLbl.text = String(qty[indexPath.row])
        
        return itemAddedCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
}

// MARK: - Extension search bar
extension CashierItemListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Start edit")
        //performSegue(withIdentifier: "toView", sender: nil)
        
        searchFooter.setIsFilteringToShow(filteredItemCount: 5, of: 11)
        //searchFooter.setNotFiltering()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("End edit")
        searchFooter.showText(text: searchBar.text!)
        //print(searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
