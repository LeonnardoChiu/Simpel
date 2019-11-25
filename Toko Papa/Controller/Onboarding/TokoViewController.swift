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
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        QueryDatabaseProfile()
        QueryDatabaseToko()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    var counter = 0
    var timer = Timer()

    
    @IBAction func doneBtn(_ sender: Any) {
        saveToCloud(namaToko: namaTokotextField.text!)
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        counter += 1
        print(counter)
        if counter == 20 {
            counter = 0
            timer.invalidate()
            QueryDatabaseToko()
            var Idss: String?
            for i in dataToko{
                if (i.value(forKey: "UniqCode") as! Int) == tempBuatCekToko{
                    Idss = i.recordID.recordName
                    break
                }
            }
            print(Idss!)
            updateToCloudProfil(tokoID: Idss!)
        }
    }
    
    
    // MARK: - Function
    /// save
    
    @objc func QueryDatabaseToko(){
        let query = CKQuery(recordType: "Toko", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.dataToko = record
        }
    }
    
    
    func saveToCloud(namaToko: String){
        let NewNote = CKRecord(recordType: "Toko")//ini buat data base baru
        NewNote.setValue(namaToko, forKey: "NamaToko")//ini ke tablenya
        var unicode = dataToko.count
        unicode = unicode + 1
        tempBuatCekToko = unicode
        NewNote.setValue(unicode, forKey: "UniqCode")
        database.save(NewNote) { (record, error) in
             print(error)
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
                    print("ASOOO")
                    print(edit.value(forKey: "lastName"))
                break
                }
            }
       
            editNote?.setValue(tokoID, forKey: "TokoID")
            editNote?.setValue("Owner", forKey: "role")//ini ke tablenya
            
        
        database.save(editNote!) { (record, error) in
             print(error)
             guard record != nil else { return}
             print("savaedddd")
         }
    }
    
    
    

}
