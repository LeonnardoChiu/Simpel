//
//  EmployeeProfileViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class EmployeeProfileViewController: UIViewController {
    
    // MARK: - IBOutlet List
    @IBOutlet weak var tableView: UITableView! {
        // hilangin sisa row table
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBAction func editBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editProfileSegue", sender: nil)
        firstNameTemp = employee!.firstName
        lastNameTemp = employee!.lastName
        storeTemp = employee!.store
        roleTemp = employee!.role
        emailTemp = employee!.email
        phoneTemp = employee!.phone
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var namaLbl: UILabel!

    // MARK: - Variable
    var textLbl: [String] = ["Store", "Role", "Email", "Phone"]
    var image: UIImage = UIImage()
    var name: String = ""
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = ""
    var emailTemp: String = ""
    var phoneTemp: String = ""
    var peoples: [People] = []
    var employee: People?
    var idx: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(orang?.firstName)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - Init profile picture
        //profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        if self.profileImage.image == nil {
            self.profileImage.image = UIImage.init(systemName: "camera")
        } else {
            self.profileImage.image = UIImage.init(systemName: "person.fill")
        }
        
        namaLbl?.text = "\(employee!.firstName) \(employee!.lastName)"
        
    }

    @IBAction func unwindToEmployeeProfile(_ unwindSegue: UIStoryboardSegue) {
        guard let EditEmployeeVC = unwindSegue.source as? EditEmployeeProfileViewController else { return }
        
    }
    
}

extension EmployeeProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textLbl.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeDetailCell") as! EmployeeProfileCell
        
        if  indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.leftText.text = textLbl[indexPath.row]
                cell.rightLbl.text = employee!.store
            }else if indexPath.row == 1 {
                cell.leftText.text = textLbl[indexPath.row]
                cell.rightLbl.text = employee!.role
            }else if indexPath.row == 2 {
                cell.leftText.text = textLbl[indexPath.row]
                cell.rightLbl.text = employee!.email
            }else if indexPath.row == 3 {
                cell.leftText.text = textLbl[indexPath.row]
                cell.rightLbl.text = employee!.phone
            }
        }
        
        idx = indexPath.row
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let vc = segue.destination as? EditEmployeeProfileViewController
            vc?.firstNameTemp = employee!.firstName
            vc?.lastNameTemp = employee!.lastName
            vc?.storeTemp = employee!.store
            vc?.roleTemp = employee!.role
            vc?.emailTemp = employee!.email
            vc?.phoneTemp = employee!.phone
            
        }
    }
}
