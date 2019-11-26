//
//  RegisterViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 25/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class RegisterViewController: UIViewController {
    var placeHolders: [String] = ["Nama Depan", "Nama Belakang", "Nomor hape"]
    var placeHoldersSection0: [String] = ["Username", "Password"]
    // MARK: - Variable
    var image: CKAsset?
    var images = UIImage()
    var roleTemp: String = ""
    
    /// Database
    let database = CKContainer.default().publicCloudDatabase
    var data: CKRecord!
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    @IBOutlet weak var profileImages: UIImageView!
    
    @IBAction func doneBtn(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
               
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        
               
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
            
        }
        appendAdd()
        alert = UIAlertController(title: "Sukses", message: "Berhasil menambahkan karyawan", preferredStyle: .alert)
               
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProfileImage()
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Function
    func initProfileImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        profileImages.addGestureRecognizer(tap)
        profileImages.isUserInteractionEnabled = true
        profileImages.image = UIImage(systemName: "camera.circle")
    }
    
    // MARK: - objc untuk profile image
    @objc func imageTap() {
        ImagePickerManager().pickImage(self) { image in
            self.images = image
            self.profileImages.image = self.images
            self.profileImages.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: - Save to cloud function
    func saveToCloud(img: UIImage, username: String, password: String, firstName: String, lastName: String, phoneNumber: String) {
        let record = CKRecord(recordType: "Profile")
        var imageURL = CKAsset(fileURL: getUrl(images)!)
                
        let resizedImage = img.resizedTo1MB()
        var asset = CKAsset(fileURL: getUrl(resizedImage!)!)
        record.setValue(asset, forKey: "profileImage")
        record.setValue(username, forKey: "UserName")
        record.setValue(password, forKey: "Password")
        record.setValue(firstName, forKey: "firstName")
        record.setValue(lastName, forKey: "lastName")
//        record.setValue("", forKey: "role")
        record.setValue(phoneNumber, forKey: "phoneNumber")
         record.setValue("-", forKey: "role")
        
        record.setValue("-", forKey: "TokoID")
        
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
    
    // MARK: - Append add
    func appendAdd() {
        let username = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterViewCell
        let password = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? RegisterViewCell
        
        let firstName = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? RegisterViewCell
        let lastName = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? RegisterViewCell
        let phone = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? RegisterViewCell
        //let role = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? RegisterViewCel
        
        self.saveToCloud(img: images, username: username!.textField.text!, password: password!.textField.text!, firstName: firstName!.textField.text!, lastName: lastName!.textField.text!, phoneNumber: phone!.textField.text!)
    }
    
    // MARK: - Unwind
    @IBAction func unwindFromRole(_ unwindSegue: UIStoryboardSegue) {
        guard let roleVC = unwindSegue.source as? RoleViewController else { return }
        
        self.roleTemp = roleVC.selectedRole
         let indexPath = IndexPath(item: 4, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

// MARK: - EXTENSION
extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return placeHoldersSection0.count
        } else {
            return placeHolders.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return " "
        }
        return ""
    }
    
    // MARK: - Did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            performSegue(withIdentifier: "toRole", sender: nil)
        }
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell") as! RegisterViewCell
        
        if indexPath.section == 0 {
            cell.textField.placeholder = placeHoldersSection0[indexPath.row]
//            if indexPath.row == 1 {
//                cell.textField.textContentType = .password
//            }
        } else {
            cell.textField.placeholder = placeHolders[indexPath.row]
        }
        
        return cell
    }
    
    
}
