//
//  AddEmployeeViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class AddEmployeeViewController: UIViewController {
        
    var peoples: People!
    var employeeArray: [People] = []
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = ""
    var emailTemp: String = ""
    var phoneTemp: String = ""
    
    @IBOutlet weak var addTableView: UITableView! {
        didSet {
            addTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var profileImages: UIImageView!
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        var alert: UIAlertController = UIAlertController()
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        var text = ""
        var title = ""
        
        // MARK: - Check if text field empty by row
        //guard let cell = addTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddEmployeeCell else { return }
       
        appendAdd()
        // employeeArray.append(People(firstName: firstNameTemp, lastName: lastNameTemp, store: storeTemp, role: roleTemp, email: emailTemp, phone: phoneTemp))
        
        /*if firstName == "" {
            text = "Nama depan harus diisi"
            title = "Ada yang kosong bos"
        } else if lastName == "" {
            text = "Nama belakang harus diisi"
            title = "Ada yang kosong bos"
        } else if store == "" {
            text = "Nama toko harus diisi"
            title = "Ada yang kosong bos"
        } else if role == "" {
            text = "Jabatan dalam toko harus diisi"
            title = "Ada yang kosong bos"
        } else if email == "" {
            text = "Email harus diisi"
            title = "Ada yang kosong bos"
        } else if phone == "" {
            text = "Nomor handphone harus diisi"
            title = "Ada yang kosong bos"
        } else if firstName != "" && lastName != "" && store != "" && role != "" && email != "" && phone != ""{
            print("ga ad aisi")
            //peoples.append(People(firstName: firstName!, lastName: lastName!, store: store!, role: role!, email: email!, phone: phone!))
            title = "Sukses"
            text = "Berhasil menambahkan karyawan baru"
            let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
                self.peoples.firstName = firstName!
                self.peoples.lastName = lastName!
                self.peoples.store = store!
                self.peoples.firstName = role!
                self.peoples.firstName = email!
                self.peoples.phone = phone!
            }
            
            alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alert.addAction(confirm)
        }*/
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
            //self.employeeArray.append(People(firstName: self.firstNameTemp, lastName: self.lastNameTemp, store: self.storeTemp, role: self.roleTemp, email: self.emailTemp, phone: self.phoneTemp))
//            self.peoples.firstName = firstName!
//            self.peoples.lastName = lastName!
//            self.peoples.store = store!
//            self.peoples.firstName = role!
//            self.peoples.firstName = email!
//            self.peoples.phone = phone!
            self.performSegue(withIdentifier: "backToList", sender: nil)
        }
        alert = UIAlertController(title: "Sukses Bos", message: "Ada orang baru nih join!", preferredStyle: .alert)
        //alert.addAction(ok)
        alert.addAction(confirm)
        alert.addAction(cancel)
        
//        peoples?.firstName = firstName!
//        peoples?.lastName = lastName!
//        peoples?.store = store!
//        peoples?.role = role!
//        peoples?.email = email!
//        peoples?.phone = phone!

//        self.firstNameTemp = firstName!
//        self.lastNameTemp = lastName!
//        self.storeTemp = store!
//        self.roleTemp = role!
//        self.emailTemp = firstName!
//        self.phoneTemp = phone!
        present(alert, animated: true, completion: nil)
   
//        if textField.text == nil {
//            let alert1 = UIAlertController(title: "Data ada yang kosong", message: "Data harus diisi semuanya", preferredStyle: .alert)
//            alert1.addAction(ok)
//            present(alert1, animated: true, completion: nil)
//        } else {
//            let alert2 = UIAlertController(title: "Sukses", message: "Berhasil menambahkan data baru", preferredStyle: .alert)
//            alert2.addAction(ok)
//            alert2.addAction(cancel)
//            present(alert2, animated: true, completion: nil)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImages.layer.cornerRadius = profileImages.frame.width / 2
        if profileImages.image == nil {
            profileImages.image = UIImage.init(systemName: "person.crop.circle.badge.plus")
        } else {
            profileImages.image = UIImage.init(systemName: "check")
        }
    }

    func appendAdd() {
        guard let cell1 = addTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddEmployeeCell else { return }
        let firstName = cell1.addFormField.text
        self.firstNameTemp = firstName!
        guard let cell2 = addTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AddEmployeeCell else { return }
        let lastName = cell2.addFormField.text
        self.lastNameTemp = lastName!
        guard let cell3 = addTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AddEmployeeCell else { return }
        let store = cell3.addFormField.text
        self.storeTemp = store!
        guard let cell4 = addTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? AddEmployeeCell else { return }
        let role = cell4.addFormField.text
        self.roleTemp = role!
        guard let cell5 = addTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? AddEmployeeCell else { return }
        let email = cell5.addFormField.text
        self.emailTemp = email!
        guard let cell6 = addTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? AddEmployeeCell else { return }
        let phone = cell6.addFormField.text
        self.phoneTemp = phone!
    }
}

extension AddEmployeeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFormCell") as! AddEmployeeCell
        
        if indexPath.row == 0 {
            cell.addFormField.placeholder = "First name"
            cell.addFormField.textContentType = .givenName
        } else if indexPath.row == 1 {
            cell.addFormField.placeholder = "Last name"
            cell.addFormField.textContentType = .familyName
        } else if indexPath.row == 2 {
            cell.addFormField.placeholder = "Store"
            cell.addFormField.textContentType = .organizationName
        } else if indexPath.row == 3 {
            cell.addFormField.placeholder = "Role"
            cell.addFormField.textContentType = .jobTitle
        } else if indexPath.row == 4 {
            cell.addFormField.placeholder = "Email"
            cell.addFormField.textContentType = .emailAddress
        } else if indexPath.row == 5 {
            cell.addFormField.placeholder = "Phone"
            cell.addFormField.textContentType = .familyName
        }
        
        return cell
    }
    
    
}
