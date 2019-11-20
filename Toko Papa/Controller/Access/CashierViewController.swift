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
    var myItem: [Item] = []
    var newItem: Item?
    var priceTemp: [Int] = []
    var totalPrice: Int = 0

    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Database
    let database = CKContainer.default().publicCloudDatabase
    
    // MARK: - IBOutlet
    @IBOutlet weak var cashierTableView: UITableView! {
        didSet{
            cashierTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Sukses", message: "Barang telah terjual", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.myItem.removeAll()
            self.cashierTableView.reloadData()
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
        
        if newItem != nil {
            totalPrice = 0
            myItem.append(newItem!)
            
            for item in myItem {
                totalPrice += item.price
            }
            
            newItem = nil
        }
        
        print("Total Price: \(totalPrice)")
        
        DispatchQueue.main.async{
                   self.cashierTableView.reloadData()
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
    
    // MARK: - Unwind list
    /// unwind dari search page
    @IBAction func unwindFromItemSearch(_ unwindSegue: UIStoryboardSegue) {
        guard let SearchItemVC = unwindSegue.source as? CashierItemListViewController else { return }
        // Use data from the view controller which initiated the unwind segue
    }
    
    /// unwind dari barcode scan page
    @IBAction func unwindFromBarcodeScanner(_ unwindSegue: UIStoryboardSegue) {
        guard let BarcodeScanVC = unwindSegue.source as? BarcodeScannerController else { return }
        // Use data from the view controller which initiated the unwind segue
    }
    
}

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
        if indexPath.row == 0 {
            tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.accessoryType = .checkmark
            tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))?.accessoryType = .none
        } else {
            tableView.cellForRow(at: IndexPath.init(row: 0, section: 1))?.accessoryType = .none
            tableView.cellForRow(at: IndexPath.init(row: 1, section: 1))?.accessoryType = .checkmark
        }
        //performSegue(withIdentifier: "toPaymentMethod", sender: nil)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if myItem.count == 0 && indexPath.section == 0 {
            // MARK: - Nampilin cell jika barang belum ada
            let noItemCell = tableView.dequeueReusableCell(withIdentifier: "CashierCell") as! CashierCell

            return noItemCell
        } else if indexPath.row == myItem.count && indexPath.section == 0 {
           // MARK: - Nampilin cell Total
            let totalCell = tableView.dequeueReusableCell(withIdentifier: "TotalPriceCell") as! TotalPriceCell
            
            //totalCell.priceNumericLbl.text = String("\(price.reduce(0, +)),00")
            totalCell.priceNumericLbl.text = "Rp. \(totalPrice.commaRepresentation)"
            
            return totalCell
        } else if myItem.count != 0 && indexPath.section == 0 {
            // MARK: - Nampilin cell barang yang dipilih
            let itemAddedCell = tableView.dequeueReusableCell(withIdentifier: "itemAddedCell") as! itemAddedCell
            
            itemAddedCell.itemNameLbl.text = myItem[indexPath.row].namaProduk
            itemAddedCell.priceLbl.text = "Rp. \(String(myItem[indexPath.row].price.commaRepresentation))"
            itemAddedCell.quantityLbl.text = "Quantity: \(String(myItem[indexPath.row].qty))"
            
            itemAddedCell.itemImage.image = myItem[indexPath.row].itemImage
            itemAddedCell.itemImage.contentMode = .scaleAspectFill
            
            return itemAddedCell
        } else if indexPath.section == 1 {
            // MARK: - nampilin cell payment method
            let paymentMethodCell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as! PaymentMethodCell
            
            if indexPath.row == 0 {
                paymentMethodCell.cashLbl.text = "Tunai"
                paymentMethodCell.accessoryType = .checkmark
            } else if indexPath.row == 1 {
                paymentMethodCell.cashLbl.text = "Non tunai"
                paymentMethodCell.accessoryType = .none
            }
            
            
            return paymentMethodCell
        }
        
        return UITableViewCell()
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
        print("tekan boss")
        performSegue(withIdentifier: "toBarcodeScanner", sender: nil)
    }
}
