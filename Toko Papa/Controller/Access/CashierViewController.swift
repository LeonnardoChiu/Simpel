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
    var item: [String] = ["Indomie kari", "Helm", "Tolak angin", "Kolor"]
    //var cash: [String] = ["a", "v", "c", "w"]
    var price: [Int] = [5000, 50000, 4600, 7400]
    var qty: [Int] = [3, 5, 21, 11]
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - IBOutlet
    @IBOutlet weak var cashierTableView: UITableView! {
        didSet{
            cashierTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(price.reduce(0, +))
        createSearchBar()
        
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
        
    }
    
    // MARK: - Search Bar in navigation
    func createSearchBar() {
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari produk"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
    }
    
//    func setupSearchBarAction() {
//        searchController.searchBar.add
//    }
    
}

extension CashierViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var row = 0
        
        switch section {
        case 0:
            row = item.count + 1
            break
        case 1:
            //row = cash.count
            row = 1
            break
        default:
            break
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print("tekan")
            performSegue(withIdentifier: "toPaymentMethod", sender: nil)
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemListCell") as! itemListTableCell
        
        if item.count == 0 && indexPath.section == 0 {
            // MARK: - Nampilin cell jika barang belum ada
            let noItemCell = tableView.dequeueReusableCell(withIdentifier: "CashierCell") as! CashierCell

            return noItemCell
        } else if indexPath.row == item.count && indexPath.section == 0{
           // MARK: - Nampilin cell Total
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "TotalPriceCell") as! TotalPriceCell
            
            totalCell.priceNumericLbl.text = String("\(price.reduce(0, +)),00")
            
            return totalCell
        } else if item.count != 0 && indexPath.section == 0 {
            // MARK: - Nampilin cell barang yang dipilih
            let itemAddedCell = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
            
            itemAddedCell.itemNameLbl.text = item[indexPath.row]
            itemAddedCell.priceLbl.text = "\(String(price[indexPath.row])),00"
            itemAddedCell.quantityLbl.text = String(qty[indexPath.row])
            
            return itemAddedCell
        } else if indexPath.section == 1 {
            // MARK: - nampilin cell payment method
            let paymentMethodCell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as! PaymentMethodCell
            
            return paymentMethodCell
        }
        return cell
    }
    
    
}

extension CashierViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("abc")
        
        performSegue(withIdentifier: "toView", sender: nil)
    }
}
