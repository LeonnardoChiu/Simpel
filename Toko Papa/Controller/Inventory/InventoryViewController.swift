//
//  InventoryViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 04/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class InventoryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    // MARK: - Variable
    let refeeshControl = UIRefreshControl()
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var filterString: String? = "NameProduct"
    var image: CKAsset?
    var sorting = true
    /// untuk search bar
    let searchController = UISearchController(searchResultsController: nil)
    var originalItem: [Inventory] = []
    var originalItemTemp: [Inventory] = []
    var searchedItem: [Inventory] = []
    var selectedItem: Inventory!
    var modelPemilik: People?
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
   
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if data.count != 0 {
            tableView.backgroundView = nil
            if isFiltering {
                //searchFooter.setIsFilteringToShow(filteredItemCount: filteredItem.count, of: myItem.count)
                count = searchedItem.count
                return searchedItem.count
            } else {
                //searchFooter.setNotFiltering()
                count = originalItem.count
                return originalItem.count
            }
            
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            noDataLabel.text = "Tidak ada barang, silahkan di tambah"
            noDataLabel.textColor = UIColor.systemRed
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return count
        //return data.count
    }
    
    // MARK: - cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostView
        
        cell.accessoryType = .disclosureIndicator
        if isFiltering {
            cell.namaProductLabel.text = searchedItem[indexPath.row].namaItem
            cell.stockLabel.text = "Stock Left : \(searchedItem[indexPath.row].stock)"
            cell.gambarCell.image = searchedItem[indexPath.row].imageItem
            return cell
        } else {
            
            cell.namaProductLabel.text = originalItem[indexPath.row].namaItem
            cell.stockLabel.text = "Stock Left : \(originalItem[indexPath.row].stock)"
            cell.gambarCell.image = originalItem[indexPath.row].imageItem
            return cell

        }
    }
    //MARK:- didselectrow table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            selectedItem = searchedItem[indexPath.row]
            tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
            
            presentedViewController?.dismiss(animated: false) {
                self.performSegue(withIdentifier: "detail", sender: self.selectedItem)
                self.searchController.searchBar.text = ""
            }
        } else {
          selectedItem = originalItem[indexPath.row]
            tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
            performSegue(withIdentifier: "detail", sender: selectedItem)
            searchController.searchBar.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail"{
            let destData = segue.destination as! DetailBarangViewController
            destData.itemDetail = selectedItem
            destData.modelPemilik = modelPemilik
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? PostView
        let string = cell?.namaProductLabel.text
        if editingStyle == .delete {
        let alert = UIAlertController(title: "Hapus", message: "Yakin Menghapus \(string!) ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("Deleted")
                    let Barang: CKRecord?
                    Barang = self.data[indexPath.row]
                    self.database.delete(withRecordID: Barang!.recordID) { (record, error) in
                        print("delete sukses")
                    }
                    self.QueryDatabase()
                    self.tableView.reloadData()

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


        }}))
        alert.addAction(UIAlertAction(title: "Batal", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        var mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
        print(mainTabBar.modelPeople?.tokoID)
        initSearchBar()
        
        self.hideKeyboardWhenTappedAround() 
        self.tableView.delegate = self
        self.tableView.dataSource = self
        /*DispatchQueue.main.async{
            self.tableView.reloadData()
        }*/
    
        refeeshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refeeshControl.addTarget(self, action: #selector(QueryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refeeshControl
    }
    
    @objc func refresh() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
         self.QueryDatabase()
    }
    
    // MARK: - objc query database
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
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
      }
    
    @IBAction func unwindFromFilterVC(segue: UIStoryboardSegue){
        guard let satuanVC = segue.source as? FilterTableViewController else { return }
        self.filterString = satuanVC.SelectedUnit!
    }
    
    @IBAction func unwindToVCInventory(_ unwindSegue: UIStoryboardSegue) {
        guard let sourceViewController = unwindSegue.source as? InventoryViewController else { return }
        // Use data from the view controller which initiated the unwind segue
    }
    
    // MARK: - init search bar
    var isSort: Bool = false
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Cari barang"
       
        searchController.searchBar.showsSearchResultsButton = true
        navigationItem.searchController = searchController
        searchController.searchBar.setImage(UIImage(systemName: "arrow.up"), for: .resultsList, state: .normal)
        searchController.searchBar.delegate = self
        //self.searchBar.delegate = searchController as? UISearchBarDelegate
    }
    
    // MARK: - init data model
    func initDataModel() {
        originalItem.removeAll()
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
            originalItem.append(Inventory(id: id, imageItem: itemImage!, namaItem: namaItem, barcode: barcode, category: category, distributor: distributor, price: price, stock: stock, version: version, unit: unit, toko: tokoID))
        }
    }
    
    // MARK: - function untuk filtering item
    func filterContentsForSearch(_ searchText: String) {
        searchedItem = originalItem.filter({ (item) -> Bool in
            return item.namaItem.lowercased().contains(searchText.lowercased())
        })
            tableView.reloadData()
    }
    
}


class PostView: UITableViewCell{
    @IBOutlet weak var namaProductLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var gambarCell: UIImageView!
}
/// extension untuk text field delegate
extension InventoryViewController: UITextFieldDelegate {
    
}
/// extension untuk search bar
extension InventoryViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentsForSearch(searchController.searchBar.text!)
    }

    /// untuk sort button dalam search bar
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        if isSort == false {
            searchBar.setImage(UIImage(systemName: "arrow.down"), for: .resultsList, state: .normal)
            isSort = true
            sorting = true
            originalItem.sort(by: { $0.namaItem > $1.namaItem })
        } else {
            searchBar.setImage(UIImage(systemName: "arrow.up"), for: .resultsList, state: .normal)
            isSort = false
            sorting = false
            originalItem.sort(by: { $0.namaItem < $1.namaItem })
            print(originalItem.count)
            print(searchedItem.count)
        }
        tableView.reloadData()
    }
    /// begin text editing
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("tekan")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchController.searchBar.text = ""
    }
    
}
