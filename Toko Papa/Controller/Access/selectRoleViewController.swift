//
//  selectRoleViewController.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 18/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class selectRoleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedRole = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent{
            print("balek")
            
            performSegue(withIdentifier: "backToAddEmployee", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roleTableCell", for: indexPath)
        let roleLabel = cell.contentView.viewWithTag(1) as! UILabel
        
        switch indexPath.row {
        case 0:
            roleLabel.text = "Pemilik"
        case 1:
            roleLabel.text = "Kasir"
        default:
            roleLabel.text = "Gudang"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            selectedRole = "Pemilik"
        case 1:
            selectedRole = "Kasir"
        default:
            selectedRole = "Gudang"
        }
    }
    
    
       

}
