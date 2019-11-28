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
    let database = CKContainer.default().publicCloudDatabase
    @IBOutlet weak var pairingTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        QueryDatabaseProfile()
        print("jumlah toko \(toko.count)")
        print("User name : \(modelPemilik?.username)")
        // Do any additional setup after loading the view.
    }
    
   
    
    @IBAction func pairingButton(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
        var alert2: UIAlertController = UIAlertController()
        
        var tokoString: String?
        var tokoIDs: String?
        var cekToko = false
        for i in toko {
            if i.uniqcode == Int(pairingTextField.text!)! {
                tokoString = i.namaToko
                tokoIDs = i.Id.recordName
                cekToko = true
                break
            }
        }
        
        
        if cekToko == true {
            alert = UIAlertController(title: "Apakah Toko Tepat?", message: "Toko : \(tokoString!) sudah bener? \n kalo sudah silahkan tekan ok", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
                self.updateToCloudProfil(tokoID: tokoIDs!)
                if let vc: MainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainTabBarController {
                    vc.modelPeople = self.modelPemilik
                    let appDelegate = UIApplication.shared.windows
                    appDelegate.first?.rootViewController = vc
                    self.present(vc, animated: true, completion: nil)
                }
              
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            present(alert, animated: true, completion: nil)
        }else{
            alert = UIAlertController(title: "Gagal", message: "kode yang di masukan salah", preferredStyle: .alert)
            let oke = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(oke)
            present(alert, animated: true, completion: nil)
        }
      
    }
    
    @objc func QueryDatabaseProfile(){
        let query = CKQuery(recordType: "Profile", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.dataProfil = record
        }
        print("Profilnya ada : \(dataProfil.count)")
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
        modelPemilik?.role = "Karyawan"
        editNote?.setValue(tokoID, forKey: "TokoID")
        editNote?.setValue("Karyawan", forKey: "role")//ini ke tablenya
        
    
    database.save(editNote!) { (record, error) in
         print(error)
         guard record != nil else { return}
         print("update")
     }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.x
    }
    */

}
}
