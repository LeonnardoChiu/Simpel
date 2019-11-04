//
//  AddInventoryViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 04/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class AddInventoryViewController: UIViewController {
    let database = CKContainer.default().publicCloudDatabase
    
    @IBOutlet weak var barcode: UITextField!
    @IBOutlet weak var nameProduct: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var stock: UITextField!
    @IBOutlet weak var distributorName: UITextField!
    @IBOutlet weak var category: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.saveToCloud(Barcode: barcode.text!, Name: nameProduct.text!, Category: category.text!, Distributor: distributorName.text!, Stock: Int(stock.text!)!, Price: Int(price.text!)!)
    }

}
