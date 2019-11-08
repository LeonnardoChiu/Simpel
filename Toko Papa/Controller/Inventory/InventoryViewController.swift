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
    let refeeshControl = UIRefreshControl()
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var filterString: String? = "NameProduct"
    var sorting = false
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostView
        let nama = data[indexPath.row].value(forKey: "NameProduct") as! String
        let stock = data[indexPath.row].value(forKey: "Stock") as! Int
        cell.namaProductLabel.text = nama
        cell.stockLabel.text = "Stock Left \(stock)"
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        refeeshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refeeshControl.addTarget(self, action: #selector(QueryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refeeshControl
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    @objc func QueryDatabase(){
          let query = CKQuery(recordType: "Inventory", predicate: NSPredicate(value: true))
          let sortDesc = NSSortDescriptor(key: filterString!, ascending: sorting)
        query.sortDescriptors = [sortDesc]
          database.perform(query, inZoneWith: nil) { (record, _) in
              guard let record = record else {return}
                //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
              self.data = record
              DispatchQueue.main.async {
                  self.tableView.refreshControl?.endRefreshing()
                  self.tableView.reloadData()
              }
          }
      }

    
    @IBOutlet weak var sortButton: UIButton!
    @IBAction func SortAsceDesc(_ sender: Any) {
        let imageDesc = UIImage(named: "descen")
        let imageAsce = UIImage(named: "ascen")
        
        if self.sorting == true{
            self.sorting = false
            sortButton.setImage(imageDesc, for: .normal)
            print("a")
        }else {
            self.sorting = true
            sortButton.setImage(imageAsce, for: .normal)
         print("b")
        }
       
        
    }
    
    
    @IBAction func unwindFromFilterVC(segue: UIStoryboardSegue){
        guard let satuanVC = segue.source as? FilterTableViewController else { return }
        self.filterString = satuanVC.SelectedUnit!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


class PostView: UITableViewCell{
    @IBOutlet weak var namaProductLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
}
