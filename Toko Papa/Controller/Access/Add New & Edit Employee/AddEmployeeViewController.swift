//
//  AddEmployeeViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 05/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class AddEmployeeViewController: UIViewController {
    
    // MARK: - Database Cloudkit
    let database = CKContainer.default().publicCloudDatabase
    
    // MARK: - Variable
    var peoples: People!
    var employeeArray: [People] = []
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = "Role"
    var emailTemp: String = ""
    var phoneTemp: String = ""
    
    let imagePicker = UIImagePickerController()
    var images = UIImage()
    var image: CKAsset?
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load tap gesture & add ke image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        profileImages.addGestureRecognizer(tap)
        profileImages.isUserInteractionEnabled = true
        doneButton.isEnabled = false
        profileImages.image = UIImage(systemName: "camera.circle")
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - Init profile picture
        profileImages.layer.cornerRadius = profileImages.frame.height / 2
        //self.profileImages.image = UIImage.init(systemName: "camera")
        if isValid() == true {
            doneButton.isEnabled = true
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var addTableView: UITableView! {
        didSet {
            addTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var profileImages: UIImageView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        var alert: UIAlertController = UIAlertController()
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        appendAdd()
        
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.performSegue(withIdentifier: "backToList", sender: nil)
        }
        
        alert = UIAlertController(title: "Sukses Bos", message: "Ada orang baru nih join!", preferredStyle: .alert)
        
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Selector method untuk tap image ambil gambar
    @objc func imageTap() {
        ImagePickerManager().pickImage(self) { image in
            self.images = image
            self.profileImages.image = self.images
            self.profileImages.contentMode = .scaleAspectFill
            if self.isValid() {
                self.doneButton.isEnabled = true
            }
        }
        
    }
    
    // MARK: - Save to cloud function
    func saveToCloud(img: UIImage, firstName: String, lastName: String, storeName: String, role: String, email: String, phoneNumber: String) {
        let record = CKRecord(recordType: "Profile")
        var imageURL = CKAsset(fileURL: getUrl(images)!)
                
        let resizedImage = img.resizedTo1MB()
        var asset = CKAsset(fileURL: getUrl(resizedImage!)!)
        record.setValue(asset, forKey: "profileImage")
        
        record.setValue(firstName, forKey: "firstName")
        record.setValue(lastName, forKey: "lastName")
        record.setValue(storeName, forKey: "storeName")
        record.setValue(role, forKey: "role")
        record.setValue(email, forKey: "email")
        record.setValue(phoneNumber, forKey: "phoneNumber")

        
        
        database.save(record) { (record, _) in
            guard record != nil else { return }
            print("Data saved to Cloud!")
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
    

    func appendAdd() {
        let firstName = addTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddEmployeeCell
        let lastName = addTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AddEmployeeCell
        let store = addTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AddEmployeeCell
        let role = addTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? AddEmployeeCell
        let email = addTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? AddEmployeeCell
        let phone = addTableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? AddEmployeeCell
        
        firstNameTemp = firstName!.addFormField.text!
        lastNameTemp = lastName!.addFormField.text!
        storeTemp = store!.addFormField.text!
        roleTemp = role!.addFormField.text!
        emailTemp = email!.addFormField.text!
        phoneTemp  = phone!.addFormField.text!
        
        self.saveToCloud(img: images, firstName: firstNameTemp, lastName: lastNameTemp, storeName: storeTemp, role: roleTemp, email: emailTemp, phoneNumber: phoneTemp)
    }
    
    @IBAction func unwindFromSelectRole (_ unwindSegue: UIStoryboardSegue){
        guard let roleVC = unwindSegue.source as? selectRoleViewController else {return}
        self.roleTemp = roleVC.selectedRole
        let indexPath = IndexPath(item: 3, section: 0)
        addTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

//EXTENSION STARTS HERE

extension AddEmployeeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textFieldTag = addTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        if (addTableView.cellForRow(at: IndexPath(row: 0, section: 0)) != nil) {
            print("row 1")
        }
        if (addTableView.cellForRow(at: IndexPath(row: 1, section: 0)) != nil) {
            print("row 222222")
        }
    }
}

extension AddEmployeeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFormCell") as! AddEmployeeCell
        
        print(roleTemp)
        
        if indexPath.row == 0 {
            cell.addFormField.placeholder = "First name"
            cell.addFormField.isEnabled = true
        } else if indexPath.row == 1 {
            cell.addFormField.placeholder = "Last name"
            cell.addFormField.isEnabled = true
        } else if indexPath.row == 2 {
            cell.addFormField.placeholder = "Store"
            cell.addFormField.isEnabled = true
        } else if indexPath.row == 3 {
            if roleTemp == "Role"{
                cell.addFormField.placeholder = roleTemp
            }
            else{
                cell.addFormField.text = roleTemp
            }
            cell.addFormField.isEnabled = false
            cell.accessoryType = .disclosureIndicator
        } else if indexPath.row == 4 {
            cell.addFormField.placeholder = "Email"
            cell.addFormField.isEnabled = true
        } else if indexPath.row == 5 {
            cell.addFormField.placeholder = "Phone"
            cell.addFormField.isEnabled = true
        }
        
        cell.addFormField.tag = indexPath.row
        cell.addFormField.addTarget(self, action: #selector(AddEmployeeViewController.textFieldDidEndEditing(_:)), for: UIControl.Event.editingChanged)
        
        return cell
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
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
    
    func isValid() -> Bool {
        if firstNameTemp == "" || lastNameTemp == "" || storeTemp == "" || roleTemp == "Role" || emailTemp == "" || phoneTemp == "" || isValidEmail(emailStr: emailTemp) == false || profileImages.image == UIImage(systemName: "camera.circle") {
            return false
        }
        else{
            return true
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "addFormCell") as! AddEmployeeCell
        
        if indexPath.row == 3 {
            performSegue(withIdentifier: "segueToRole", sender: self)
        }
    }
    
    
}
