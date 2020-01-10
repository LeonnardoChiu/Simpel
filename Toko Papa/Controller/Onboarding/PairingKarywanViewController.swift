//
//  PairingKarywanViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 28/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class PairingKarywanViewController: UIViewController {
    var modelPemilik: People?
    var toko: [Toko] = []
    var dataProfil = [CKRecord]()
    var datatoko = [CKRecord]()
    let database = CKContainer.default().publicCloudDatabase
    @IBOutlet weak var pairingTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
   
    var tokoString: String?
    var tokoIDs: String?
    @IBAction func pairingButton(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
        
        
        
        self.QueryDatabaseToko(uniq: pairingTextField.text!) { (status) in
            if status == true{
                self.tokoIDs = self.datatoko.first?.recordID.recordName
                self.tokoString = self.datatoko.first?.value(forKey: "NamaToko") as! String
                DispatchQueue.main.async {
                    alert = UIAlertController(title: "Apakah Toko Tepat?", message: "Toko : \(self.tokoString!) sudah bener? \n kalo sudah silahkan tekan ok", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
                    let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
                        
                        self.QueryDatabaseProfile(appleid: self.modelPemilik!.appleID) { (status) in
                            self.updateToCloudProfil(tokoID: self.tokoIDs!) { (status) in
                                DispatchQueue.main.async {
                                    if let vc: MainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainTabBarController {
                                        vc.modelPeople = self.modelPemilik
                                        vc.appleid = ""
                                        let appDelegate = UIApplication.shared.windows
                                        appDelegate.first?.rootViewController = vc
                                        self.present(vc, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                    alert.addAction(cancel)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }else{
                alert = UIAlertController(title: "Gagal", message: "kode yang di masukan salah", preferredStyle: .alert)
                let oke = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(oke)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func QueryDatabaseToko(uniq: String, completion: @escaping (Bool)-> Void){
            
           let query = CKQuery(recordType: "Toko", predicate: NSPredicate(format: "UniqCode == %@", uniq))
           database.perform(query, inZoneWith: nil) { (record, _) in
               guard let record = record else {return}
               self.datatoko = record
               print("jumlah toko : \(self.datatoko.count)")
                
           }
            if datatoko.count != 0{
                  completion(true)
                
            }else{
                completion(false)
            }
        
       }
    
    @objc func QueryDatabaseProfile(appleid: String, completion: @escaping (Bool)-> Void){
        let query = CKQuery(recordType: "Profile", predicate: NSPredicate(format: "AppleID == %@", appleid))
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
            self.dataProfil = record
             completion(true)
        }
        print("Profilnya ada : \(dataProfil.count)")
    }
    
    func updateToCloudProfil(tokoID: String, completion: @escaping (Bool)-> Void){
        var editNote: CKRecord?
        editNote = dataProfil.first
        modelPemilik?.tokoID = tokoID
        modelPemilik?.role = "Karyawan"
        editNote?.setValue(tokoID, forKey: "TokoID")
        editNote?.setValue("Karyawan", forKey: "role")//ini ke tablenya
        
    
    database.save(editNote!) { (record, error) in
         //print(error)
         guard record != nil else { return}
         print("update")
        completion(true)
     }

}
}
