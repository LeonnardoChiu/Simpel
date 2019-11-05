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
    @IBOutlet weak var tableView: UITableView!
    
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
        
        refeeshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refeeshControl.addTarget(self, action: #selector(QueryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refeeshControl
    }
    
    @objc func QueryDatabase(){
          let query = CKQuery(recordType: "Inventory", predicate: NSPredicate(value: true))
          database.perform(query, inZoneWith: nil) { (record, _) in
              guard let record = record else {return}
              let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
              self.data = sortedRecord
              DispatchQueue.main.async {
                  self.tableView.refreshControl?.endRefreshing()
                  self.tableView.reloadData()
              }
          }
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
