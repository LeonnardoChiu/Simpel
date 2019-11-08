//
//  profileViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 08/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var peoples: [People] = []
    // Delegate
    weak var delegate: EmployeeListViewController?
    
    // init model
    var Budi = People(firstName: "Budi", lastName: "Santoso", store: "Toko Papa Jaya", role: "Papa", email: "budibudi@gmail.com", phone: "0812314123")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        else {
            return "Settings"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableID", for: indexPath)
        
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let valueLabel = cell.contentView.viewWithTag(2) as! UILabel
        valueLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        if indexPath.section == 1 {
            valueLabel.isHidden = true
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        if indexPath == [0,0]{
            nameLabel.text = "Store Name"
            valueLabel.text = Budi.store
        }
        else if indexPath == [0,1]{
            nameLabel.text = "Role"
            valueLabel.text = Budi.role
        }
        else if indexPath == [0,2]{
            nameLabel.text = "Email"
            valueLabel.text = Budi.email
        }
        else if indexPath == [0,3]{
            nameLabel.text = "Phone Number"
            valueLabel.text = Budi.phone
        }
        
        if indexPath == [1,0] {
            nameLabel.text = "Security"
        }
        else if indexPath == [1,1] {
            nameLabel.text = "About Us"
        }
        else if indexPath == [1,2] {
            nameLabel.text = "Sign Out"
        }
        
        return cell
    }
    

}
