//
//  EmployeeProfileViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class EmployeeProfileViewController: UIViewController {
    
    // MARK: - Database Cloudkit
    let database = CKContainer.default().publicCloudDatabase
    var data: CKRecord!
    
    // MARK: - Variable
    var textLbl: [String] = ["Store", "Role"]
    var image: CKAsset?
    var name: String = ""
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = ""
    var emailTemp: String = ""
    var phoneTemp: String = ""
    var modelUser: People?
    var toko: Toko?
    
    var profileCell: [String] = []
    var idx: Int = 0
    
    // MARK: - IBOutlet List
    @IBOutlet weak var tableView: UITableView! {
        // hilangin sisa row table
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editProfileSegue", sender: data)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var namaLbl: UILabel!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        appendToArray()
        firstNameTemp = modelUser!.firstName
        
    }
    
    // MARK: - viewDidAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        
        namaLbl.text = "\(firstNameTemp) \(lastNameTemp)"
        
    }
    
 
    
    // MARK: - function append cloud data to array
    func appendToArray() {
        profileCell.append(modelUser!.role)
    }
    
    
    
}
// MARK: - EXTENSION
extension EmployeeProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textLbl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeDetailCell") as! EmployeeProfileCell
        cell.leftText.text = textLbl[indexPath.row]
        
        
        idx = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
