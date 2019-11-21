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
    var profileCell: [String] = []
    
    // MARK: - Variable
    var textHolder: [String] = ["First name", "Last name", "Store", "Role", "Email", "Phone"]
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = "Role"
    var emailTemp: String = ""
    var phoneTemp: String = ""
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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        var alert: UIAlertController = UIAlertController()
        //let cell = EditEmployeeCell()
        updateProfile()
        
        let ok = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.performSegue(withIdentifier: "backToListFromEdit", sender: nil)
            
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        appendToArray()
        print(profileCell[0])
        roleTemp = profileCell[3]
        // MARK: - Load tap gesture & add ke image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        profileImages.addGestureRecognizer(tap)
        profileImages.isUserInteractionEnabled = true
        showImage()
        doneButton.isEnabled = false
        firstNameTemp = profileCell[0]
        lastNameTemp = profileCell[1]
        storeTemp = profileCell[2]
        roleTemp = profileCell[3]
        emailTemp = profileCell[4]
        phoneTemp = profileCell[5]
        print(firstNameTemp)
        print(lastNameTemp)
        print(storeTemp)
        print(roleTemp)
        print(emailTemp)
        print(phoneTemp)
        print(isValid())
        if isValid() {
            doneButton.isEnabled = true
        }
    }

    // MARK: viewWillAppear
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
    
    // MARK: - function for show image
    func showImage() {
        image = editData.value(forKey: "profileImage") as? CKAsset
        if let image = image, let url = image.fileURL, let data = NSData(contentsOf: url) {
            self.profileImages.image = UIImage(data: data as Data)
            self.profileImages.contentMode = .scaleAspectFill
        } else {
            self.profileImages.image = UIImage.init(systemName: "person.crop.circle.badge.plus")
        }
    }
    
    // MARK: - function for appending cloud data to array
    func appendToArray() {
        profileCell.append(editData.value(forKey: "firstName") as! String)
        profileCell.append(editData.value(forKey: "lastName") as! String)
        profileCell.append(editData.value(forKey: "storeName") as! String)
        profileCell.append(editData.value(forKey: "role") as! String)
        profileCell.append(editData.value(forKey: "email") as! String)
        profileCell.append(editData.value(forKey: "phoneNumber") as! String)
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
    }
    
    
    func isValid() -> Bool {
        if firstNameTemp == "" || lastNameTemp == "" || storeTemp == "" || roleTemp == "Role" || emailTemp == "" || phoneTemp == "" || isValidEmail(emailStr: emailTemp) == false || profileImages.image == UIImage(systemName: "camera.circle") {
            return false
        }
        else{
            return true
        }
    }
    
    @objc func textFieldDidChangeSelection(_ textField: UITextField) {
           let textFieldRow = textField.tag
           print(textFieldRow)
           if textFieldRow == 0 {
               if textField.text == "" {
                   textField.attributedPlaceholder = NSAttributedString(string: "First Name must be Filled", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
               }
               firstNameTemp = textField.text!
           }
           if textFieldRow == 1 {
               if textField.text == "" {
                   textField.attributedPlaceholder = NSAttributedString(string: "Last Name must be Filled", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
               }
               lastNameTemp = textField.text!
           }
           if textFieldRow == 2{
               if textField.text == "" {
                   textField.attributedPlaceholder = NSAttributedString(string: "Store Name must be Filled", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
               }
               storeTemp = textField.text!
           }
           if textFieldRow == 3 {
               if textField.text == "" {
                   textField.attributedPlaceholder = NSAttributedString(string: "Role must be Selected", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
               }
               roleTemp = textField.text!
           }
           if textFieldRow == 4 {
               if textField.text == "" {
                   textField.attributedPlaceholder = NSAttributedString(string: "Email must be Filled", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
               }
               else{
                   if isValidEmail(emailStr: textField.text!) == false {
                       textField.textColor = UIColor.red
                   }
                   else{
                       textField.textColor = UIColor.black
                   }
               }
               emailTemp = textField.text!
           }
           if textFieldRow == 5 {
               if textField.text == "" {
               textField.attributedPlaceholder = NSAttributedString(string: "Phone must be Filled", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                   
               doneButton.isEnabled = false
               }
               phoneTemp = textField.text!
               
           }
           
           if isValid() == false {
               doneButton.isEnabled = false
           }
           else{
               doneButton.isEnabled = true
           }

       }
    
     func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    @IBAction func unwindFromSelectRole (_ unwindSegue: UIStoryboardSegue){
        guard let roleVC = unwindSegue.source as? selectRoleViewController else {return}
        self.roleTemp = roleVC.selectedRole
        print(self.roleTemp)
        let indexPath = IndexPath(item: 3, section: 0)
        editTableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
}

extension EditEmployeeProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textHolder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editFormCell") as! EditEmployeeCell
        
        if indexPath.row == 0 {
            cell.editTextField.text = profileCell[indexPath.row]
            cell.editTextField.isEnabled = true
            //cell.editTextField.text = profileCell[indexPath.row]
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 1 {
            cell.editTextField.text = profileCell[indexPath.row]
            cell.editTextField.isEnabled = true
            //cell.editTextField.text = profileCell[indexPath.row]
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 2 {
            cell.editTextField.text = profileCell[indexPath.row]
            cell.editTextField.isEnabled = true
            //cell.editTextField.text = profileCell[indexPath.row]
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 3 {
            cell.editTextField.text = roleTemp
            cell.editTextField.isEnabled = false
            //cell.editTextField.text = profileCell[indexPath.row]
            cell.leftLbl.text = textHolder[indexPath.row]
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 4 {
            cell.editTextField.text = profileCell[indexPath.row]
            cell.editTextField.isEnabled = true
            //cell.editTextField.text = profileCell[indexPath.row]
            cell.leftLbl.text = textHolder[indexPath.row]
        } else if indexPath.row == 5 {
            cell.editTextField.text = profileCell[indexPath.row]
            cell.editTextField.isEnabled = true
            //cell.editTextField.text = profileCell[indexPath.row]
            cell.leftLbl.text = textHolder[indexPath.row]
        }
        
        cell.editTextField.tag = indexPath.row
        cell.editTextField.addTarget(self, action: #selector(EditEmployeeProfileViewController.textFieldDidChangeSelection(_:)), for: UIControl.Event.editingChanged)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
        
        if indexPath.row == 3 {
            performSegue(withIdentifier: "segueToRole", sender: self)
        }
    }
    
}
