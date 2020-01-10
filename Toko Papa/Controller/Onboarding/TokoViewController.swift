//
//  TokoViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 25/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class TokoViewController: UIViewController {

    // MARK: - Variable
    let database = CKContainer.default().publicCloudDatabase
    var modelPemilik: People?
    var modelProfile: [People] = []
    var dataProfil = [CKRecord]()
    var dataToko = [CKRecord]()
    var tempBuatCekToko: String?
    var image: CKAsset?
    var people: [People] = []
    // MARK: - IBOutlet
    @IBOutlet weak var namaTokotextField: UITextField!
    @IBOutlet weak var selesai: UIBarButtonItem!
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    var counter = 0
    var timer = Timer()
    var ceknamatoko = false
    var kontertoko = 0
    var cekupdatetocloud = false
    var konterupdate = 0
     var Idss: String?
    @IBAction func doneBtn(_ sender: Any) {
        
        var alert: UIAlertController = UIAlertController()
        var alert2: UIAlertController = UIAlertController()
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
           self.selesai.isEnabled = true
            self.ceknamatoko = false
            self.kontertoko = 0
            self.konterupdate = 0
            self.cekupdatetocloud = false
           alert2 = UIAlertController(title: "mohon menunggu", message: "tunggu beberapa detik", preferredStyle: .alert)
           self.present(alert2, animated: true, completion: nil)
           
            self.saveToCloud(namaToko: self.namaTokotextField.text!) { (status) in
                if status == true {
                    print(self.tempBuatCekToko)
                    self.QueryDatabaseToko(uniqcode: self.tempBuatCekToko!) { (status) in
                        if status == true{
                            print(self.Idss)
                            self.QueryDatabaseProfile(appleid: self.modelPemilik!.appleID) { (status) in
                                self.updateToCloudProfil(tokoID: self.Idss!) { (status) in
                                    DispatchQueue.main.sync {
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
                        
                    }
                }
                
                
            }
           
        }
        alert = UIAlertController(title: "Nama Toko sudah benar?", message: "Jika sudah bener tekan ok", preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
        
        
    }
    // MARK: - Function
    /// save
    
    @objc func QueryDatabaseToko(uniqcode: String, completion: @escaping (Bool)-> Void){
        let query = CKQuery(recordType: "Toko", predicate: NSPredicate(format: "UniqCode == %@", uniqcode))
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.dataToko = record
            self.Idss = self.dataToko.first?.recordID.recordName
            completion(true)
             print("jumlah toko : \(self.dataToko.count)")
        }
    }
    
    
    func saveToCloud(namaToko: String, completion: @escaping (Bool)-> Void){
        print("test")
        let NewNote = CKRecord(recordType: "Toko")//ini buat data base baru
        NewNote.setValue(namaToko, forKey: "NamaToko")//ini ke tablenya
        let unicode = Int(generateRandomDigits(6))!
        print(unicode)
        tempBuatCekToko = String(unicode)
        NewNote.setValue(tempBuatCekToko, forKey: "UniqCode")
        database.save(NewNote) { (record, error) in
            if error == nil {
             guard record != nil else { return}
             print("savaedddd")
            completion(true)
            }
            else{
                print(error)
            }
         }
        
    }
    
    
    
    
    /// update
    @objc func QueryDatabaseProfile(appleid: String, completion: @escaping (Bool)-> Void){
        let query = CKQuery(__recordType: "Profile", predicate: NSPredicate(format: "AppleID == %@", appleid))
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else { return }
            //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
            self.dataProfil = record
            
            for i in self.modelProfile{
                print(i.appleID)
                print(i.firstName)
           }
            completion(true)
            print("Total Employee dalam database : \(self.dataProfil.count)")
        }
    }
    
    
    func updateToCloudProfil(tokoID: String,completion: @escaping (Bool)-> Void){
            var editNote: CKRecord?
            editNote = dataProfil.first
            editNote?.setValue(tokoID, forKey: "TokoID")
            editNote?.setValue("Owner", forKey: "role")//ini ke tablenya
            
        
        database.save(editNote!) { (record, error) in
             //print(error)
             guard record != nil else { return}
             print("savaedddd")
            completion(true)
         }
    }
    
    
    
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }

    
    
}
