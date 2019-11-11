//
//  editProfileViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 11/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class editProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var firstName = String()
    var lastName = String()
    var store = String()
    var role = String()
    var email = String()
    var phone = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 6
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTableCellID", for: indexPath)
           
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let valueText = cell.contentView.viewWithTag(2) as! UITextField
        
        valueText.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        nameLabel.text = "\(indexPath)"
        
        if indexPath.row == 0 {
            nameLabel.text = "First Name"
            valueText.placeholder = firstName
        }
        else if indexPath.row == 1 {
            nameLabel.text = "Last Name"
            valueText.placeholder = lastName
        }
        else if indexPath.row == 2 {
            nameLabel.text = "Store Name"
            valueText.placeholder = store
        }
        else if indexPath.row == 3 {
            nameLabel.text = "Role"
            valueText.placeholder = role
        }
        else if indexPath.row == 4 {
            nameLabel.text = "Email"
            valueText.placeholder = email
        }
        else {
            nameLabel.text = "Phone Number"
            valueText.placeholder = phone
        }
        
        return cell
    }
       
}
