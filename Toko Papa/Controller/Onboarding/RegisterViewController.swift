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
    
    // MARK: - Variable
    var placeHolders: [String] = ["Nama Depan", "Nama Belakang","Email","Nomor telp"]
    var isiCellforRow: [String] = []
    var user: User?
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    
    var image: CKAsset?
    var images = UIImage()
    var roleTemp: String = ""
    var usernameTemp = ""
    var passwordTemp = ""
    var namaDepanTemp = ""
    var namaBelakangTemp = ""
    var nomorHpTemp = ""
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var selesai: UIBarButtonItem!
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
    var counter = 0
    var timer = Timer()

    @IBAction func doneBtn(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
        var alert2: UIAlertController = UIAlertController()
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.selesai.isEnabled = true
          
            alert2 = UIAlertController(title: "mohon menunggu", message: "kurang lebih 15 detik", preferredStyle: .alert)
            self.present(alert2, animated: true, completion: nil)
           
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
        
        
        
        
        alert = UIAlertController(title: "Data Sudah Bener?", message: "Jika sudah bener tekan ok", preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func timerAction() {
        counter += 1
        print(counter)
        
        if counter == 1 {
            self.appendAdd()
        }
        if counter == 15 {
            counter = 0
            timer.invalidate()
            performSegue(withIdentifier: "backtoLogin", sender: nil)
        }
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
//        doneButton.isEnabled = false
        errorLabel.isHidden = true
        initProfileImage()
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isiCellforRow.append(user!.firstName)
        isiCellforRow.append(user!.lastName)
        isiCellforRow.append(user!.email)
        isiCellforRow.append("")
        print(String(user?.debugDescription ?? ""))
        print("Your Apple ID : \(user?.id)")
        print("First name    : \(user?.firstName)")
        print("Last name     : \(user?.lastName)")
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
//            self.validate()
        }
    }
    
//    func validate() {
//        if usernameTemp == "" || passwordTemp == "" || namaDepanTemp == "" || namaBelakangTemp == "" || nomorHpTemp == "" {
//            doneButton.isEnabled = false
//        }
//
//        else if profileImages.image == UIImage(systemName: "camera.circle") {
//            errorLabel.isHidden = false
//            doneButton.isEnabled = false
//        }
//        else {
//            doneButton.isEnabled = true
//            errorLabel.isHidden = true
//        }
//    }
    
    // MARK: - Save to cloud function
    func saveToCloud(img: UIImage, AppleID: String, Email: String, firstName: String, lastName: String, phoneNumber: String) {
        let record = CKRecord(recordType: "Profile")
        var imageURL = CKAsset(fileURL: getUrl(images)!)
                
        let resizedImage = img.resizedTo1MB()
        var asset = CKAsset(fileURL: getUrl(resizedImage!)!)
        record.setValue(asset, forKey: "profileImage")
        record.setValue(AppleID, forKey: "AppleID")
        record.setValue(Email, forKey: "Email")
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
        let firstName = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterViewCell
        let lastName = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? RegisterViewCell
        let phone = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? RegisterViewCell
        //let role = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? RegisterViewCel
        
        self.saveToCloud(img: images, AppleID: user!.id, Email: user!.email,  firstName: firstName!.textField.text!, lastName: lastName!.textField.text!, phoneNumber: phone!.textField.text!)
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
        return placeHolders.count
    }
    
   
    
    // MARK: - Did select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
        
    }
    
   
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell") as! RegisterViewCell
        
        cell.textField.placeholder = placeHolders[indexPath.row]
        cell.textField.text = isiCellforRow[indexPath.row]
        return cell
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate {
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        let textFieldRow = textField.tag
//
//        if textFieldRow == 0 {
//            if textField.text == "" {
//                textField.attributedPlaceholder = NSAttributedString(string: "Username harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            }
//            usernameTemp = textField.text!
//
//        }
//
//        if textFieldRow == 1 {
//            if textField.text == "" {
//                textField.attributedPlaceholder = NSAttributedString(string: "Password harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            }
//            passwordTemp = textField.text!
//
//        }
//
//        if textFieldRow == 2 {
//            if textField.text == "" {
//                textField.attributedPlaceholder = NSAttributedString(string: "Nama Depan harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            }
//            namaDepanTemp = textField.text!
//
//        }
//
//        if textFieldRow == 3 {
//            if textField.text == "" {
//                textField.attributedPlaceholder = NSAttributedString(string: "Nama Belakang harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            }
//            namaBelakangTemp = textField.text!
//
//        }
//
//        if textFieldRow == 4 {
//            if textField.text == "" {
//                textField.attributedPlaceholder = NSAttributedString(string: "Nomor Hp harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            }
//            nomorHpTemp = textField.text!
//
//        }
//        validate()
//
//    }
}
