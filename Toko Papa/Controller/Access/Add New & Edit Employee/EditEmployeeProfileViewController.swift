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
    var editData: CKRecord!
    var textFieldTemp: [String] = []
    
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
    var images = UIImage()

    // MARK: - IBOutlet
    @IBOutlet weak var editTableView: UITableView! {
        didSet {
            editTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        var alert: UIAlertController = UIAlertController()
        //let cell = EditEmployeeCell()
        updateProfile()
        
        let ok = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.performSegue(withIdentifier: "backToList", sender: nil)
            
            //self.firstNameTemp = cell.editTextField.text!
            //self.updateProfile()
        }
        
        alert = UIAlertController(title: "Berhasil Edit", message: "Data profile berhasil diperbarui", preferredStyle: .alert)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var profileImages: UIImageView!
    
    // MARK: - Selector method untuk tap image ambil gambar
    @objc func imageTap() {
        ImagePickerManager().pickImage(self) { image in
            self.images = image
            self.profileImages.image = self.images
            self.profileImages.contentMode = .scaleAspectFill
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Load tap gesture & add ke image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        profileImages.addGestureRecognizer(tap)
        profileImages.isUserInteractionEnabled = true
        showImage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileImages.layer.cornerRadius = profileImages.frame.height / 2
        // MARK: - ambil data dari cloudkit dalam bentuk URL
        // image harus diload dengan type NSData fileURL
        if let data = NSData(contentsOf: image!.fileURL!) {
            self.profileImages.image = UIImage(data: data as Data)
            self.profileImages.contentMode = .scaleAspectFill
        } else {
            profileImages.image = UIImage.init(systemName: "person.crop.circle.badge.plus")
        }
        
    }
    
    func showImage() {
        image = editData.value(forKey: "profileImage") as? CKAsset
        if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
            self.profileImages.image = UIImage(data: data as Data)
            self.profileImages.contentMode = .scaleAspectFill
        } else {
            self.profileImages.image = UIImage.init(systemName: "person.crop.circle.badge.plus")
        }
    }
    
    // MARK: - Update data cloud
    func UpdateToCloud(img: UIImage, firstName: String, lastName: String, storeName: String, role: String, email: String, phoneNumber: String, editRecord: CKRecord){
        //let record = CKRecord(recordType: "Profile")
        var user = editRecord
        var imageURL = CKAsset(fileURL: getUrl(images)!)

                
        let resizedImage = img.resizedTo1MB()
        var asset = CKAsset(fileURL: getUrl(resizedImage!)!)
        
        user.setValue(asset, forKey: "profileImage")
        user.setValue(firstName, forKey: "firstName")
        user.setValue(lastName, forKey: "lastName")
        user.setValue(storeName, forKey: "storeName")
        user.setValue(role, forKey: "role")
        user.setValue(email, forKey: "email")
        user.setValue(phoneNumber, forKey: "phoneNumber")
        
        
         database.save(user) { (record, error) in
             guard record != nil else { return}
             print("Updated")
         }
    }
    
    func getUrl(_ images: UIImage) -> URL?{
        let data = images.pngData(); // UIImage -> NSData, see also UIImageJPEGRepresentation
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data!.write(to:url!, options: [])
            
        } catch let e as NSError {
            print("Error! \(e)");
            return nil
        }
        
        return url
    }
    
    // MARK: - Update function
    func updateProfile() {
        
        guard let firstName = editTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditEmployeeCell else { return }
        guard let lastName = editTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditEmployeeCell else { return }
        guard let store = editTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditEmployeeCell else { return }
        guard let role = editTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? EditEmployeeCell else { return }
        guard let email = editTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? EditEmployeeCell else { return }
        guard let phone = editTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? EditEmployeeCell else { return }
        
        self.UpdateToCloud(img: images, firstName: (firstName.editTextField.text)!, lastName: (lastName.editTextField.text)!, storeName: (store.editTextField.text)!, role: (role.editTextField.text)!, email: (email.editTextField.text)!, phoneNumber: (phone.editTextField.text)!, editRecord: editData)
        
//        firstNameTemp = firstName!.editTextField.text!
//        lastNameTemp = lastName!.editTextField.text!
//        storeTemp = store!.editTextField.text!
//        roleTemp = role!.editTextField.text!
//        emailTemp = email!.editTextField.text!
//        phoneTemp  = phone!.editTextField.text!
        
        //UpdateToCloud(img: image!, firstName: firstNameTemp, lastName: lastNameTemp, storeName: storeTemp, role: roleTemp, email: emailTemp, phoneNumber: phoneTemp, editRecord: editData)
    }
    
}

extension EditEmployeeProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textHolder.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
}
