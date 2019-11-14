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
    var textLbl: [String] = ["Store", "Role", "Email", "Phone"]
    var image: CKAsset?
    var name: String = ""
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = ""
    var emailTemp: String = ""
    var phoneTemp: String = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendArray()
        firstNameTemp = data.value(forKey: "firstName") as! String
        lastNameTemp = data.value(forKey: "lastName") as! String
        //self.QueryDatabase()
        //print(orang?.firstName)
        showImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.QueryDatabase()
        // MARK: - Init profile picture
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        // MARK: - ambil data dari cloudkit dalam bentuk URL
        // image harus diload dengan type NSData fileURL
        
            /*
            if let data = NSData(contentsOf: image!.fileURL!) {
                self.profileImage.image = UIImage(data: data as Data)
                self.profileImage.contentMode = .scaleAspectFill
            } else {
                self.profileImage.image = UIImage.init(systemName: "camera")

            }*/

        namaLbl.text = "\(firstNameTemp) \(lastNameTemp)"
    }
    
    func showImage() {
        image = data.value(forKey: "profileImage") as? CKAsset
        if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
            self.profileImage.image = UIImage(data: data as Data)
            self.profileImage.contentMode = .scaleAspectFill
        } else {
            self.profileImage.image = UIImage.init(systemName: "camera")
        }
    }
    
    func appendArray() {
        //profileCell.append(data.value(forKey: "firstName") as! String)
        //profileCell.append(data.value(forKey: "lastName") as! String)
        profileCell.append(data.value(forKey: "storeName") as! String)
        profileCell.append(data.value(forKey: "role") as! String)
        profileCell.append(data.value(forKey: "email") as! String)
        profileCell.append(data.value(forKey: "phoneNumber") as! String)
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
                //cell.rightLbl.text = storeTemp
                cell.rightLbl.text = profileCell[indexPath.row]
            }else if indexPath.row == 1 {
                cell.leftText.text = textLbl[indexPath.row]
                //cell.rightLbl.text = roleTemp
                cell.rightLbl.text = (data.value(forKey: "role") as! String)
            }else if indexPath.row == 2 {
                cell.leftText.text = textLbl[indexPath.row]
                //cell.rightLbl.text = emailTemp
                cell.rightLbl.text = (data.value(forKey: "email") as! String)
            }else if indexPath.row == 3 {
                cell.leftText.text = textLbl[indexPath.row]
                //cell.rightLbl.text = phoneTemp
                cell.rightLbl.text = (data.value(forKey: "phoneNumber") as! String)
            }
        }
        
        idx = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let vc = segue.destination as! EditEmployeeProfileViewController
//            vc?.firstNameTemp = firstNameTemp
//            vc?.lastNameTemp = lastNameTemp
//            vc?.storeTemp = storeTemp
//            vc?.roleTemp = roleTemp
//            vc?.emailTemp = emailTemp
//            vc?.phoneTemp = phoneTemp
//            vc?.image = image
            
            vc.editData = sender as! CKRecord
        }
    }
}
