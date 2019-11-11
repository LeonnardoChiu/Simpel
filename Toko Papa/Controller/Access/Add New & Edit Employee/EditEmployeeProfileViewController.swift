//
//  EditEmployeeProfileViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 06/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class EditEmployeeProfileViewController: UIViewController {
    
    // MARK: - Database CloudKit
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    
    // MARK: - Variable
    var textHolder: [String] = ["First name", "Last name", "Store", "Role", "Email", "Phone"]
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = ""
    var emailTemp: String = ""
    var phoneTemp: String = ""
    var peoples: [People] = []
    var employee: People?
    var idx: Int = 0
    
    let imagePicker = UIImagePickerController()
    var image: CKAsset?
    var imageTemp = UIImage()

    // MARK: - IBOutlet
    @IBOutlet weak var editTableView: UITableView! {
        didSet {
            editTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        var alert: UIAlertController = UIAlertController()
        
        //updateProfile()
        
        let ok = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.performSegue(withIdentifier: "backToEmployeeProfile", sender: nil)
        }
        
        alert = UIAlertController(title: "Berhasil Edit", message: "Data profile berhasil diperbarui", preferredStyle: .alert)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var profileImages: UIImageView!
    
    // MARK: - Selector method untuk tap image ambil gambar
    @objc func imageTap() {
        ImagePickerManager().pickImage(self) { image in
            self.imageTemp = image
            self.profileImages.image = self.imageTemp
            self.profileImages.contentMode = .scaleAspectFill
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Load tap gesture & add ke image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        profileImages.addGestureRecognizer(tap)
        profileImages.isUserInteractionEnabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImages.layer.cornerRadius = profileImages.frame.height / 2
        if profileImages.image == nil {
            profileImages.image = UIImage.init(systemName: "person.crop.circle.badge.plus")
        }
    }
    
    // MARK: - Save to cloud
    func saveToCloud(img: CKAsset) {
        let record = CKRecord(recordType: "Profile")
        record.setValue(img, forKey: "profileImage")
        
        database.save(record) { (record, _) in
            guard record != nil else { return }
        }
    }
    
    func updateProfile() {
        guard let cell1 = editTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditEmployeeCell else { return }
        let firstName = cell1.editTextField.text
        self.firstNameTemp = firstName!
        guard let cell2 = editTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditEmployeeCell else { return }
        let lastName = cell2.editTextField.text
        self.lastNameTemp = lastName!
        guard let cell3 = editTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditEmployeeCell else { return }
        let store = cell3.editTextField.text
        self.storeTemp = store!
        guard let cell4 = editTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? EditEmployeeCell else { return }
        let role = cell4.editTextField.text
        self.roleTemp = role!
        guard let cell5 = editTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? EditEmployeeCell else { return }
        let email = cell5.editTextField.text
        self.emailTemp = email!
        guard let cell6 = editTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? EditEmployeeCell else { return }
        let phone = cell6.editTextField.text
        self.phoneTemp = phone!
    }
    
}

extension EditEmployeeProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editFormCell") as! EditEmployeeCell
        
        let firstController = EmployeeProfileViewController()
        
        if indexPath.row == 0 {
            cell.editTextField.placeholder = "First name"
            cell.editTextField.text = firstNameTemp
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 1 {
            cell.editTextField.placeholder = "Last name"
            cell.editTextField.text = lastNameTemp
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 2 {
            cell.editTextField.placeholder = "Store"
            cell.editTextField.text = storeTemp
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 3 {
            cell.editTextField.placeholder = "Role"
            cell.editTextField.text = roleTemp
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 4 {
            cell.editTextField.placeholder = "Email"
            cell.editTextField.text = emailTemp
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 5 {
            cell.editTextField.placeholder = "Phone"
            cell.editTextField.text = phoneTemp
            cell.leftLbl.text = textHolder[indexPath.row]
        }
        
        return cell
    }
    
    
}
