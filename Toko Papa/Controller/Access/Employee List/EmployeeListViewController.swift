//
//  EmployeeListViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class EmployeeListViewController: UIViewController {
    
    // MARK: - Variable
    var images: UIImage?
    var karyawan: [People] = []
    var owner: [People] = []
    var toko: [Toko] = []
    var rowKaryawan: [Bool] = []
    var rowOwner: [Bool] = []
    let refreshControl = UIRefreshControl()
    
    // MARK: - Database Cloudkit
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var modelPemilik: People?
    var idx: Int = 0
    var image: CKAsset?
    
    // MARK: - IBOutlet list
    @IBOutlet weak var tableList: UITableView! {
        // hilangin sisa row table
        didSet {
            tableList.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBAction func logOutBtn(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: "userLogin")
        UserDefaults.standard.set("", forKey: "appleId")
        if let vc: OnboardingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingStoryboard") as? OnboardingViewController {
            let appDelegate = UIApplication.shared.windows
            appDelegate.first?.rootViewController = vc
            self.present(vc, animated: true, completion: nil)
        }
    }
    
   // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.QueryDatabase()
        // MARK: - buat pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(QueryDatabaseKaryawan), for: .valueChanged)
        self.tableList.refreshControl = refreshControl
    }
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.QueryDatabaseKaryawan()
        let mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
       
        images = modelPemilik?.image
        
      
    }
    
   
    // MARK: - obj function untuk nampilin data Query Database
    @objc func QueryDatabaseKaryawan(){
        let mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
        
        let tokoID = modelPemilik?.tokoID
        let queryKaryawan = CKQuery(recordType: "Profile", predicate: NSPredicate(format: "TokoID == %@ && role == %@", tokoID!, "Karyawan"))
        
        database.perform(queryKaryawan, inZoneWith: nil) { (record, _) in
            guard let record = record else { return }
            self.data = record
            self.ModelKaryawan()
            
            DispatchQueue.main.async {
                self.tableList.refreshControl?.endRefreshing()
                self.tableList.reloadData()
            }
            print("Total Karyawan dalam database : \(self.karyawan.count)")
        }
        
        let queryOwner = CKQuery(recordType: "Profile", predicate: NSPredicate(format: "TokoID == %@ && role == %@", tokoID!, "Owner"))
        database.perform(queryOwner, inZoneWith: nil) { (record, _) in
            guard let record = record else { return }
            self.data = record
            self.ModelOwner()
            DispatchQueue.main.async {
                self.tableList.refreshControl?.endRefreshing()
                self.tableList.reloadData()
            }
            print("Total Owner dalam database : \(self.owner.count)")
        }
        
        let tokoIDReference = CKRecord.Reference(recordID: CKRecord.ID(recordName: modelPemilik!.tokoID), action: .none)
        let query = CKQuery(recordType: "Toko", predicate: NSPredicate(format: "recordID == %@", tokoIDReference))
    
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.data = record
            self.ModelToko()
            /// append ke model
            print("jumlah code : \(self.data.count)")
        }
        
        
    }
    
    // MARK: - Function model toko
    func ModelToko() {
        toko.removeAll()
        for countData in data {
            let id = countData.recordID
            let namaToko = countData.value(forKey: "NamaToko") as! String
            let Uniq = countData.value(forKey: "UniqCode") as! Int
            toko.append(Toko(id: id, namatoko: namaToko,uniq: Uniq))
        }
    }
    
    func ModelOwner() {
        owner.removeAll()
        rowOwner.removeAll()
        
       for countData in data {
            let id = countData.recordID
            let appleid = countData.value(forKey: "AppleID") as! String
            let email = countData.value(forKey: "Email") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let lastName = countData.value(forKey: "lastName") as! String
            let phone = countData.value(forKey: "phoneNumber") as! String
            let roleee = countData.value(forKey: "role") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
        
            //var profileImage: UIImage?
            image = (countData.value(forKey: "Images") as? [CKAsset])?.first
            if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
                //profileImage = UIImage(data: data as Data)
                //itemImage.contentMode = .scaleAspectFill
                images = UIImage(data: data as Data)
            }
//            let refr = CKRecord.ID(recordName: "-")
            owner.append(People(id: id, appleid: appleid, email: email, firstName: firstName, lastName: lastName, phone: phone, rolee: roleee, toko: tokoID, profileImage: images!))
            if id.recordName == modelPemilik?.Id.recordName{
                rowOwner.append(true)
            }else{
                rowOwner.append(false)
            }
       }
    }
    
    func ModelKaryawan() {
        karyawan.removeAll()
        rowKaryawan.removeAll()
        for countData in data {
            let id = countData.recordID
            let appleid = countData.value(forKey: "AppleID") as! String
            let email = countData.value(forKey: "Email") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let lastName = countData.value(forKey: "lastName") as! String
            let phone = countData.value(forKey: "phoneNumber") as! String
            let roleee = countData.value(forKey: "role") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
            
            //var profileImage: UIImage?
            image = (countData.value(forKey: "Images") as? [CKAsset])?.first
            if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
                //profileImage = UIImage(data: data as Data)
                //itemImage.contentMode = .scaleAspectFill
                images = UIImage(data: data as Data)
            }
            
            karyawan.append(People(id: id, appleid: appleid, email: email,  firstName: firstName, lastName: lastName, phone: phone, rolee: roleee, toko: tokoID, profileImage: images!))
            //karyawan.append(People(id: id, appleid: appleid, email: email,  firstName: firstName, lastName: lastName, phone: phone, rolee: roleee, toko: tokoID, profileImage: UIImage(systemName: "camera.fill")!))
            if id.recordName == modelPemilik?.Id.recordName{
                rowKaryawan.append(true)
            }else{
                rowKaryawan.append(false)
            }
        }
    }

}

// MARK: - EXTENSION
extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return owner.count
        }else if section == 1 {
            if modelPemilik?.role == "Karyawan"{
                return karyawan.count
            }else{
                return (karyawan.count + 1)
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Karyawan"
        }
        return ""
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeListCell
        let cellCode = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell.selectionStyle = .none
        cellCode?.selectionStyle = .none
        
        if indexPath.section == 0 {
            let firstName = owner[indexPath.row].firstName
            let lastName = owner[indexPath.row].lastName
            let role = owner[indexPath.row].role
            cell.namaLbl.text = "\(firstName) \(lastName)"
            cell.accessLbl.text = "\(role)"
            if rowOwner[indexPath.row] == true{
                cell.namaLbl.textColor = UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                cell.accessLbl.textColor = UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                
                
            }
            return cell
        }else if indexPath.section == 1 {
            if modelPemilik?.role == "Karyawan"{
                
                let firstName = karyawan[indexPath.row].firstName
                let lastName = karyawan[indexPath.row].lastName
                let role = karyawan[indexPath.row].role
                cell.namaLbl.text = "\(firstName) \(lastName)"
                cell.accessLbl.text = "\(role)"
                if rowKaryawan[indexPath.row] == true{
                    cell.namaLbl.textColor = UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                    cell.accessLbl.textColor = UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
                    
                    
                }
                return cell
            }else{
                if karyawan.count == 0 {
                    return cellCode!
                }else{
                    if indexPath.row < karyawan.count{
                        print(indexPath.row)
                        let firstName = karyawan[indexPath.row].firstName
                        let lastName = karyawan[indexPath.row].lastName
                        let role = karyawan[indexPath.row].role
                        cell.namaLbl.text = "\(firstName) \(lastName)"
                        cell.accessLbl.text = "\(role)"
                        return cell
                    }else{
                        return cellCode!
                    }
                }
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
        
        if indexPath.section == 0 {
            if modelPemilik?.role == "Owner" {
                //modelPemilik = owner[idx]
                idx = indexPath.row
                //performSegue(withIdentifier: "employeeProfileSegue", sender: owner[indexPath.row])
            } else {
                
                
            }
        } else if indexPath.section == 1 {
            //print(modelPemilik?.role)
            if karyawan.count == 0 {
                performSegue(withIdentifier: "code", sender: nil)
            } else {
                if indexPath.row < karyawan.count {
                    //modelPemilik = karyawan[indexPath.row]
                    idx = indexPath.row
                    //performSegue(withIdentifier: "employeeProfileSegue", sender: karyawan[indexPath.row])
                }else{
                    performSegue(withIdentifier: "code", sender: nil)
                }
            }
            
        }
        
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    // MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "employeeProfileSegue" {
            let vc = segue.destination as! EmployeeProfileViewController
            
            //vc.data = sender as! CKRecord
            if modelPemilik?.role == "Owner" {
                vc.modelUser = sender as? People
                vc.toko = toko[idx]
//                vc.modelUser = owner[idx]
            } else if modelPemilik?.role == "Karyawan" {
                vc.modelUser = sender as? People
                vc.toko = toko[idx]
//                vc.modelUser = karyawan[idx]
            }
            
            
        }
        if segue.identifier == "code" {
            let vc = segue.destination as! CodeViewController
            
            vc.tokoCode = toko[0]
        }
    }
    
}
