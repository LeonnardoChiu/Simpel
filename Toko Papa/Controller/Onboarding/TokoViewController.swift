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
    var dataProfil = [CKRecord]()
    var dataToko = [CKRecord]()
    var tempBuatCekToko: Int?
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
        QueryDatabaseProfile()
        QueryDatabaseToko()
        
    }
    
    var counter = 0
    var timer = Timer()

    
    @IBAction func doneBtn(_ sender: Any) {
        
        var alert: UIAlertController = UIAlertController()
        var alert2: UIAlertController = UIAlertController()
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
           self.selesai.isEnabled = true
         
           alert2 = UIAlertController(title: "mohon menunggu", message: "kurang lebih 15 detik", preferredStyle: .alert)
           self.present(alert2, animated: true, completion: nil)
          
           self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
        alert = UIAlertController(title: "Nama Toko sudah benar?", message: "Jika sudah bener tekan ok", preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func timerAction() {
        counter += 1
        QueryDatabaseToko()
        QueryDatabaseProfile()
        print(counter)
        if counter == 1 {
            saveToCloud(namaToko: namaTokotextField.text!)
        }
        if counter == 8 {
            var Idss: String?
            for i in dataToko{
                if Int(i.value(forKey: "UniqCode") as! Int) == tempBuatCekToko{
                    Idss = i.recordID.recordName
                    break
                }
            }
            
            updateToCloudProfil(tokoID: Idss!)
        }
        
        if counter == 15 {
            counter = 0
            timer.invalidate()
           if let vc: MainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainTabBarController {
               vc.modelPeople = modelPemilik
               let appDelegate = UIApplication.shared.windows
               appDelegate.first?.rootViewController = vc
               self.present(vc, animated: true, completion: nil)
           }
        }
    }
    
    // MARK: - Function
    /// save
    
    @objc func QueryDatabaseToko(){
        let query = CKQuery(recordType: "Toko", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.dataToko = record
            print(self.dataToko.count)
        }
    }
    
    
    func saveToCloud(namaToko: String){
        let NewNote = CKRecord(recordType: "Toko")//ini buat data base baru
        NewNote.setValue(namaToko, forKey: "NamaToko")//ini ke tablenya
        var unicode = Int(generateRandomDigits(6))!
        print(unicode)
        tempBuatCekToko = unicode
        NewNote.setValue(unicode, forKey: "UniqCode")
        database.save(NewNote) { (record, error) in
             guard record != nil else { return}
             print("savaedddd")
         }
    }
    
    
    
    
    /// update
    @objc func QueryDatabaseProfile(){
        let query = CKQuery(recordType: "Profile", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.dataProfil = record
        }
    }
    
   
    
    func updateToCloudProfil(tokoID: String){
            var editNote: CKRecord?
            
            for edit in dataProfil{
                if modelPemilik?.Id.recordName == edit.recordID.recordName{
                editNote = edit
                break
                }
            }
            modelPemilik?.tokoID = tokoID
            modelPemilik?.role = "Owner"
            editNote?.setValue(tokoID, forKey: "TokoID")
            editNote?.setValue("Owner", forKey: "role")//ini ke tablenya
            
        
        database.save(editNote!) { (record, error) in
             //print(error)
             guard record != nil else { return}
             print("savaedddd")
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
