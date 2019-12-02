//
//  TambahSatuanViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 18/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class TambahSatuanViewController: UIViewController {
    var modelPemilik: People?
    @IBOutlet weak var tambahSatuanTextField: UITextField!
     let database = CKContainer.default().publicCloudDatabase
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func simpanButton(_ sender: Any) {
        performSegue(withIdentifier: "backtoSatuan", sender: nil)
       saveToCloud(tambah: tambahSatuanTextField.text!, tokoId: modelPemilik!.tokoID)
    }
    func saveToCloud(tambah: String, tokoId: String){
        let newNote = CKRecord(recordType: "Satuan")
         newNote.setValue(tokoId, forKey: "TokoID")
        newNote.setValue(tambah, forKey: "SatuanBarang")
        database.save(newNote) { (record, error) in
            print(error)
            guard record != nil else { return}
            print("savaedddd")
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
