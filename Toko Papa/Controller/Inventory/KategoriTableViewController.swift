//
//  KategoriTableViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 15/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class KategoriTableViewController: UITableViewController {
    
    let refeeshControl = UIRefreshControl()
    var selectedKategori: String?
    var pemilihVC: Int?
    let database = CKContainer.default().publicCloudDatabase
    var kategoriCloud = [CKRecord]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tableView.tableFooterView = UIView(frame: .zero)
        refeeshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refeeshControl.addTarget(self, action: #selector(QueryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refeeshControl
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        self.QueryDatabase()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kategoriCloud.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cells = tableView.visibleCells
         for myCell in cells {
             myCell.accessoryType = .none
         }
        
         guard let cell = tableView.cellForRow(at: indexPath) else {return}
         cell.accessoryType = .checkmark
         tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
         
        self.selectedKategori = cell.textLabel?.text
         if pemilihVC == 0 {
             performSegue(withIdentifier: "backToAddVC", sender: nil)
         }else if pemilihVC == 1 {
             performSegue(withIdentifier: "backToEditVC", sender: nil)
         }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let kategori = kategoriCloud[indexPath.row].value(forKey: "CategoryName") as! String
        if let selected = selectedKategori,selected == kategori{
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = kategori
        return cell
    }

   
    @objc func QueryDatabase(){
        let query = CKQuery(recordType: "Category", predicate: NSPredicate(value: true))
//        let sortDesc = NSSortDescriptor(key: filterString!, ascending: sorting)
//      query.sortDescriptors = [sortDesc]
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
              //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
            self.kategoriCloud = record
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func unwindFromKategoriBarang(segue: UIStoryboardSegue){
        guard let satuanVC = segue.source as? TambahCategoryViewController else { return }
    }
    
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
        let string = cell?.textLabel?.text
            if editingStyle == .delete {
            let alert = UIAlertController(title: "Hapus", message: "Yakin Menghapus \(string!) ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("Deleted")
                        let deleteCategori: CKRecord?
                        deleteCategori = self.kategoriCloud[indexPath.row]
                        self.database.delete(withRecordID: deleteCategori!.recordID) { (record, error) in
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
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
