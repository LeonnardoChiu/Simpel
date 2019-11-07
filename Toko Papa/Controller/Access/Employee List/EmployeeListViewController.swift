//
//  EmployeeListViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController {
    
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
    
    // MARK: - Variable
    // var people: [String] = ["Budi", "Ade", "Andi"]
    // var access: [String] = ["Owner", "Cashier", "Inventorist"]
    var peoples: [People] = []
    // Delegate
    weak var delegate: EmployeeListViewController?
    
    // init model
    var Budi = People(firstName: "Budi", lastName: "Santoso", store: "Toko Papa Jaya", role: "Papa", email: "budibudi@gmail.com", phone: "0812314123")
    
    var Ade = People(firstName: "Ade", lastName: "Liason", store: "Toko Papa Jaya", role: "Paman", email: "adeade@gmail.com", phone: "2131412312")
    
    var Andi = People(firstName: "Andi", lastName: "Karim", store: "Toko Papa Jaya", role: "Anak Sulung", email: "andiandi@gmail.com", phone: "90839184")
    
    var Avira = People(firstName: "Avira", lastName: "Santoso", store: "Toko Papa Jaya", role: "Anak Bungsu", email: "viravira@gmail.com", phone: "13219541")
    
    var temp: Int = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationItem.titleView = UIImageView(image: UIImage.init(systemName: "person.fill"))
        peoples.append(Budi)
        peoples.append(Ade)
        peoples.append(Andi)
        peoples.append(Avira)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        if segue.identifier == "employeeProfileSegue" {

            let vc = segue.destination as? EmployeeProfileViewController
            vc?.name = people[temp]
            
        }
    }*/
    
}

extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! EmployeeListCell
        
        /*cell.namaLbl.text = people[indexPath.row]
        cell.accessLbl.text = access[indexPath.row]*/
        cell.namaLbl.text = "\(peoples[indexPath.row].firstName) \(peoples[indexPath.row].lastName)"
        cell.accessLbl.text = peoples[indexPath.row].role

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        tableView.deselectRow(at: indexPath, animated: true)
        //print(self.people[indexPath.row], " \(self.access[indexPath.row])")
        
        print("\(self.peoples[indexPath.row].firstName) \(self.peoples[indexPath.row].lastName)")
        
        temp = indexPath.row

        performSegue(withIdentifier: "employeeProfileSegue", sender: peoples[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "employeeProfileSegue" {
            let vc = segue.destination as? EmployeeProfileViewController
            vc?.employee = peoples[temp]
            
        }
    }
    
}
