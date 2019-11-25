//
//  RoleViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 25/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class RoleViewController: UIViewController {

    // MARK: - Variable
    var selectedRole = "Pemilik"
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - View will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            performSegue(withIdentifier: "backToRegister", sender: nil)
        }
    }
}

// MARK: - EXTENSION
extension RoleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roleCell", for: indexPath) as! RoleViewCell
        //let roleLabel = cell.contentView.viewWithTag(1) as! UILabel
        
        switch indexPath.row {
        case 0:
            cell.roleLbl.text = "Pemilik"
        case 1:
            cell.roleLbl.text = "Kasir"
        default:
            cell.roleLbl.text = "Gudang"
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
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
}
