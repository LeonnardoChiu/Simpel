//
//  AddInventoryViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 04/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class AddInventoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SatuanDelegate{
   
    func satuan(data: String) {
        satuanSekarang = data
    }
    var satuanSekarang: String?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Tambahbarangcell
        let cells = UITableViewCell()
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.tambahBarangTextField.placeholder = "Barcode"
                cell.PieceLabel.text = ""
                return cell
                
            case 1:
                 cell.tambahBarangTextField.placeholder = "Nama Product"
                 cell.PieceLabel.text = ""
                return cell
            case 2:
                cell.tambahBarangTextField.placeholder = "Category"
                cell.PieceLabel.text = ""
                return cell
                
            case 3:
                cell.tambahBarangTextField.placeholder = "Distributor"
                cell.PieceLabel.text = ""
                return cell
            
            case 4:
                cell.tambahBarangTextField.placeholder = "Stock"
                cell.PieceLabel.text = ""
                return cell
            default:
                return cells
            }
        
        case 1:
            if indexPath.row == 0 {
                cell.tambahBarangTextField.placeholder = "Price per Piece"
                    cell.PieceLabel.text = satuanSekarang
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        default:
             return cells
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                performSegue(withIdentifier: "satuan", sender: satuanSekarang)
                tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "satuan"{
            let vc = segue.destination as! SatuanBarangTableViewController
//            vc.ceklis = sender as! [Bool]
            
        }
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }else if section == 1 {
            return "Price List"
        }
        return ""
    }
    
    
    let database = CKContainer.default().publicCloudDatabase
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func saveToCloud(Barcode: String, Name: String, Category:String, Distributor:String, Stock:Int, Price: Int){
            let NewNote = CKRecord(recordType: "Inventory")//ini buat data base baru
            NewNote.setValue(Barcode, forKey: "Barcode")//ini ke tablenya
            NewNote.setValue(Category, forKey: "Category")
            NewNote.setValue(Distributor, forKey: "Distributor")
            NewNote.setValue(Name, forKey: "NameProduct")
            NewNote.setValue(Price, forKey: "Price")
            NewNote.setValue(Stock, forKey: "Stock")
        
         database.save(NewNote) { (record, error) in
             print(error)
             guard record != nil else { return}
             print("savaedddd")
         }
    }

    @IBAction func doneButton(_ sender: Any) {
//        self.saveToCloud(Barcode: barcode.text!, Name: nameProduct.text!, Category: category.text!, Distributor: distributorName.text!, Stock: Int(stock.text!)!, Price: Int(price.text!)!)
    }

}

class Tambahbarangcell: UITableViewCell{
    
    @IBOutlet weak var tambahBarangTextField: UITextField!
    @IBOutlet weak var PieceLabel: UILabel!
    
}
