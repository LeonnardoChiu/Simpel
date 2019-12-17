//
//  ChooseRoleViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 25/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class ChooseRoleViewController: UIViewController {

    
    // MARK: - Variable
    
    /// database
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var toko: [Toko] = []
    var modelPemilik: People?
    var people: [People] = []
    var image: CKAsset?
    // MARK: - IBOutlet
    @IBOutlet weak var ownerView: UIView! {
        didSet {
            ownerView.layer.shadowRadius = 10
        }
    }
    
    @IBOutlet weak var karyawanView: UIView!
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        QueryDatabaseKaryawan()
        let gestureOwner: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Owner))
        // or declare like this
        let gestureKaryawan: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Karyawan))

        //modelPemilik?.appleID
       
        self.ownerView.addGestureRecognizer(gestureOwner)
        self.karyawanView.addGestureRecognizer(gestureKaryawan)

    }
    
    @objc func QueryDatabaseKaryawan(){
        
        let query = CKQuery(recordType: "Toko", predicate: NSPredicate(value: true))
    
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.data = record
            self.ModelToko()
            /// append ke model
            print("jumlah toko : \(self.data.count)")
        }
        

    }
    
    
    func initDataModel() {
        people.removeAll()
        for countData in data {
            let id = countData.recordID
            let appleid = countData.value(forKey: "AppleID") as! String
            let email = countData.value(forKey: "Email") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let lastName = countData.value(forKey: "lastName") as! String
            let phone = countData.value(forKey: "phoneNumber") as! String
            let roleee = countData.value(forKey: "role") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
            
            var profileImage: UIImage?
            image = (countData.value(forKey: "Images") as? [CKAsset])?.first
            if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
                profileImage = UIImage(data: data as Data)
                //itemImage.contentMode = .scaleAspectFill
            }
            
            people.append(People(id: id, appleid: appleid, email: email,  firstName: firstName, lastName: lastName, phone: phone, rolee: roleee, toko: tokoID, profileImage: UIImage(systemName: "camera.fill")!))
        }
    }
    
    
    func ModelToko() {
        toko.removeAll()
        for countData in data {
            let id = countData.recordID
            let namaToko = countData.value(forKey: "NamaToko") as! String
            let Uniq = countData.value(forKey: "UniqCode") as! Int
            
            toko.append(Toko(id: id, namatoko: namaToko,uniq: Uniq))
        }
       
    }
    
    
    
    @objc func Owner() {
       performSegue(withIdentifier: "ownerToko", sender: nil)
    }
    
    @objc func Karyawan() {
       performSegue(withIdentifier: "karyawan", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ownerToko"{
            guard let vc = segue.destination as? TokoViewController else { return }
                vc.modelPemilik = modelPemilik
                vc.people = people
        }
        
        
        if segue.identifier == "karyawan"{
            guard let vc = segue.destination as? PairingKarywanViewController else { return }
                vc.modelPemilik = modelPemilik
                vc.toko = toko
        }
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
