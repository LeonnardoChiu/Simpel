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
    var karyawan: [People] = []
    var owner: [People] = []
    var toko: [Toko] = []
    let refreshControl = UIRefreshControl()
    
    // MARK: - Database Cloudkit
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var modelPemilik: People?
    var idx: Int = 0
    // MARK: - IBOutlet list
    @IBOutlet weak var tableList: UITableView! {
        // hilangin sisa row table
        didSet {
            tableList.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBAction func addBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewEmployeeSegue", sender: nil)
    }
    
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.QueryDatabase()
        // MARK: - buat pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(QueryDatabaseKaryawan), for: .valueChanged)
        self.tableList.refreshControl = refreshControl
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.QueryDatabaseKaryawan()
        var mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
        print(mainTabBar.modelPeople?.tokoID)
        print(mainTabBar.modelPeople?.role)
    }
    
    
    
    
    
    // MARK: - Unwind untuk Add
    @IBAction func unwindToEmployeeAccess(_ unwindSegue: UIStoryboardSegue) {
        print(#function)
        guard let AddEmployeeVC = unwindSegue.source as? AddEmployeeViewController else { return }
    }
    
    // MARK: - Unwind untuk Edit
    @IBAction func unwindToEditVc(_ unwindSegue: UIStoryboardSegue) {
        guard let EditEmployeVC = unwindSegue.source as? EditEmployeeProfileViewController else { return }
        // Use data from the view controller which initiated the unwind segue
    }
    
    // MARK: - obj function untuk nampilin data Query Database
    @objc func QueryDatabaseKaryawan(){
        var mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
        print(mainTabBar.modelPeople?.firstName)
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
            print("Total Karyawab dalam database : \(self.karyawan.count)")
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
    
    func ModelToko() {
        toko.removeAll()
        for countData in data {
            let namaToko = countData.value(forKey: "NamaToko") as! String
            let Uniq = countData.value(forKey: "UniqCode") as! Int
            
            toko.append(Toko(namatoko: namaToko,uniq: Uniq))
        }
        print(toko[0].uniqcode)
        print(toko[0].namaToko)
    }
    
    func ModelOwner() {
        owner.removeAll()
        for countData in data {
            let id = countData.recordID
            let username = countData.value(forKey: "UserName") as! String
            let password = countData.value(forKey: "Password") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let lastName = countData.value(forKey: "lastName") as! String
            let phone = countData.value(forKey: "phoneNumber") as! String
            let roleee = countData.value(forKey: "role") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
            owner.append(People(id: id, username: username, password: password, firstName: firstName, lastName: lastName, phone: phone, rolee: roleee, toko: tokoID))
        }
    }
    
    func ModelKaryawan() {
        karyawan.removeAll()
        for countData in data {
            let id = countData.recordID
            let username = countData.value(forKey: "UserName") as! String
            let password = countData.value(forKey: "Password") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let lastName = countData.value(forKey: "lastName") as! String
            let phone = countData.value(forKey: "phoneNumber") as! String
            let roleee = countData.value(forKey: "role") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
            karyawan.append(People(id: id, username: username, password: password, firstName: firstName, lastName: lastName, phone: phone, rolee: roleee, toko: tokoID))
        }
    }
    
}



extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return owner.count
        }else if section == 1 {
            return (karyawan.count + 1)
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
        if indexPath.section == 0 {
            let firstName = owner[indexPath.row].firstName
            let lastName = owner[indexPath.row].lastName
            let role = owner[indexPath.row].role
            cell.namaLbl.text = "\(firstName) \(lastName)"
            cell.accessLbl.text = "\(role)"
            return cell
        }else if indexPath.section == 1 {
            if karyawan.count == 0 {
                return cellCode!
            }else{
                let firstName = karyawan[indexPath.row].firstName
                let lastName = karyawan[indexPath.row].lastName
                let role = karyawan[indexPath.row].role
                cell.namaLbl.text = "\(firstName) \(lastName)"
                cell.accessLbl.text = "\(role)"
                return cell
                if indexPath.row == (karyawan.count + 1){
                    return cellCode!
                }
            }
           
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idx = indexPath.row
     
        if indexPath.section == 1 {
            if karyawan.count == 0 {
                   performSegue(withIdentifier: "code", sender: nil)
            }else{
               
                if indexPath.row == (karyawan.count + 1){
                       performSegue(withIdentifier: "code", sender: nil)
                }
            }
           
        }
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "employeeProfileSegue" {
            let vc = segue.destination as! EmployeeProfileViewController
            
            vc.data = sender as! CKRecord
        }
        if segue.identifier == "code" {
            let vc = segue.destination as! CodeViewController
            
            vc.tokoCode = toko[0]
        }
    }
    
}
