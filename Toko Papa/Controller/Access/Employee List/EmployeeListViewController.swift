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
    var peoples: [People] = []
    let refreshControl = UIRefreshControl()
    
    // MARK: - Database Cloudkit
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    
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
    
   /* // init model
    var Budi = People(firstName: "Budi", lastName: "Santoso", store: "Toko Papa Jaya", role: "Papa", email: "budibudi@gmail.com", phone: "0812314123")
    
    var Ade = People(firstName: "Ade", lastName: "Liason", store: "Toko Papa Jaya", role: "Paman", email: "adeade@gmail.com", phone: "2131412312")
    
    var Andi = People(firstName: "Andi", lastName: "Karim", store: "Toko Papa Jaya", role: "Anak Sulung", email: "andiandi@gmail.com", phone: "90839184")
    
    var Avira = People(firstName: "Avira", lastName: "Santoso", store: "Toko Papa Jaya", role: "Anak Bungsu", email: "viravira@gmail.com", phone: "13219541")*/
    
    var idx: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.titleView = UIImageView(image: UIImage.init(systemName: "person.fill"))
        //self.QueryDatabase()
        // MARK: - buat pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(QueryDatabase), for: .valueChanged)
        self.tableList.refreshControl = refreshControl
        self.QueryDatabase()
        /*peoples.append(Budi)
        peoples.append(Ade)
        peoples.append(Andi)
        peoples.append(Avira)*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableList.reloadData()
        //print("New added : \(peoples.last?.firstName) \(peoples.last?.lastName) to your list!")
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        if segue.identifier == "employeeProfileSegue" {

            let vc = segue.destination as? EmployeeProfileViewController
            vc?.name = people[temp]
            
        }
    }*/
    
    
    @IBAction func unwindToEmployeeAccess(_ unwindSegue: UIStoryboardSegue) {
        print(#function)
        guard let AddEmployeeVC = unwindSegue.source as? AddEmployeeViewController else {return}
        self.peoples.append(People(firstName: AddEmployeeVC.firstNameTemp, lastName: AddEmployeeVC.lastNameTemp, store: AddEmployeeVC.storeTemp, role: AddEmployeeVC.roleTemp, email: AddEmployeeVC.emailTemp, phone: AddEmployeeVC.phoneTemp))
    }
    
    // MARK: - obj function untuk nampilin data Query Database
    @objc func QueryDatabase(){
        let query = CKQuery(recordType: "Profile", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else { return }
            //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
            self.data = record
            DispatchQueue.main.async {
                self.tableList.refreshControl?.endRefreshing()
                self.tableList.reloadData()
            }
            print(self.data.first?.value(forKey: "profileImage"))
            print("Total Employee dalam database : \(self.data.count)")
        }
        
    }
    
}

extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if data.count == 0{
            return 1
        }
        else{
            return data.count
        }*/
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeListCell
        
        /*cell.namaLbl.text = people[indexPath.row]
        cell.accessLbl.text = access[indexPath.row]*/
        
        /*if data.count == 0 {
            cell.namaLbl.text = "No Data"
            cell.accessLbl.isHidden = true
        }
        else {
            // cell.namaLbl.text = "\(peoples[indexPath.row].firstName) \(peoples[indexPath.row].lastName)"
            // cell.accessLbl.text = peoples[indexPath.row].role
            
        }*/
        let firstName = data[indexPath.row].value(forKey: "firstName") as! String
        let lastName = data[indexPath.row].value(forKey: "lastName") as! String
        let role = data[indexPath.row].value(forKey: "role") as! String
        
        cell.namaLbl.text = "\(firstName) \(lastName)"
        cell.accessLbl.text = "\(role)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        tableView.deselectRow(at: indexPath, animated: true)
        //print(self.people[indexPath.row], " \(self.access[indexPath.row])")
        
        //print("\(self.peoples[indexPath.row].firstName) \(self.peoples[indexPath.row].lastName)")
        
        idx = indexPath.row

        //performSegue(withIdentifier: "employeeProfileSegue", sender: peoples[indexPath.row])
        performSegue(withIdentifier: "employeeProfileSegue", sender: data[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "employeeProfileSegue" {
            let vc = segue.destination as? EmployeeProfileViewController
            
            vc?.firstNameTemp = data[idx].value(forKey: "firstName") as! String
            vc?.lastNameTemp = data[idx].value(forKey: "lastName") as! String
            vc?.storeTemp = data[idx].value(forKey: "storeName") as! String
            vc?.roleTemp = data[idx].value(forKey: "role") as! String
            vc?.emailTemp = data[idx].value(forKey: "email") as! String
            vc?.phoneTemp = data[idx].value(forKey: "phoneNumber") as! String
            vc?.image = data[idx].value(forKey: "profileImage") as! CKAsset
            //vc?.employee = peoples[idx]
            //vc?.peoples.append(peoples[idx])
        }
    }
    
}
