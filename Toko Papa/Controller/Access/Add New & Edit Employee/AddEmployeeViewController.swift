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
    var data = [CKRecord]()
    
    // MARK: - Variable
    var peoples: People!
    var employeeArray: [People] = []
    var firstNameTemp: String = ""
    var lastNameTemp: String = ""
    var storeTemp: String = ""
    var roleTemp: String = ""
    var emailTemp: String = ""
    var phoneTemp: String = ""
    
    let imagePicker = UIImagePickerController()
    var images = UIImage()
    var image: CKAsset?
    
    // MARK: - IBOutlet
    @IBOutlet weak var addTableView: UITableView! {
        didSet {
            addTableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    @IBOutlet weak var profileImages: UIImageView!
    
    @IBAction func doneBtn(_ sender: UIBarButtonItem) {
        var alert: UIAlertController = UIAlertController()
        //let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //var text = ""
        //var title = ""
        
        appendAdd()
    
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.performSegue(withIdentifier: "backToList", sender: nil)
        }
        
        alert = UIAlertController(title: "Sukses Bos", message: "Ada orang baru nih join!", preferredStyle: .alert)
        //alert.addAction(ok)
        alert.addAction(confirm)
        alert.addAction(cancel)
    
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Selector method untuk tap image ambil gambar
    @objc func imageTap() {
        ImagePickerManager().pickImage(self) { image in
            self.images = image
            self.profileImages.image = self.images
            self.profileImages.contentMode = .scaleAspectFill
        }
    }
    
    // MARK: - show query database
    @objc func QueryDatabase() {
        let query = CKQuery(recordType: "Profile", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else { return }
            
            self.data = record
            DispatchQueue.main.async {
                self.addTableView.refreshControl?.endRefreshing()
                self.addTableView.reloadData()
            }
        }
    }
    
    // MARK: - Save to cloud function
    func saveToCloud(img: UIImage, firstName: String, lastName: String, storeName: String, role: String, email: String, phoneNumber: String) {
        let record = CKRecord(recordType: "Profile")
       
        record.setValue(firstName, forKey: "firstName")
        record.setValue(lastName, forKey: "lastName")
        record.setValue(storeName, forKey: "storeName")
        record.setValue(role, forKey: "role")
        record.setValue(email, forKey: "email")
        record.setValue(phoneNumber, forKey: "phoneNumber")
        
        var imageURL = CKAsset(fileURL: getUrl(images)!)
        record.setValue(imageURL, forKey: "profileImage")
        
        database.save(record) { (record, _) in
            guard record != nil else { return }
            print("Data saved to Cloud!")
        }
    }
    
    /*func saveToClouds(Barcode: String, Name: String, Category:String, Distributor:String, Stock:Int, Price: Int, image:[UIImage]){
            let NewNote = CKRecord(recordType: "Inventory")//ini buat data base baru
            NewNote.setValue(Barcode, forKey: "Barcode")//ini ke tablenya
            NewNote.setValue(Category, forKey: "Category")
            NewNote.setValue(Distributor, forKey: "Distributor")
            NewNote.setValue(Name, forKey: "NameProduct")
            NewNote.setValue(Price, forKey: "Price")
            NewNote.setValue(Stock, forKey: "Stock")
        
            var imageAsset: [CKAsset] = []
               
            for gambar in image {
                var asset = CKAsset(fileURL: getUrl(gambar)!)
                imageAsset.append(asset)
                print("aaa")
            }
       
            NewNote.setValue(imageAsset, forKey: "Image")
        
        
         database.save(NewNote) { (record, error) in
             print(error)
             guard record != nil else { return}
             print("savaedddd")
         }
    }*/
    
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load tap gesture & add ke image view
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        profileImages.addGestureRecognizer(tap)
        profileImages.isUserInteractionEnabled = true
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - Init profile picture
        profileImages.layer.cornerRadius = profileImages.frame.height / 2
        //self.profileImages.image = UIImage.init(systemName: "camera")
    }

    func appendAdd() {
        /*guard let cell1 = addTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddEmployeeCell else { return }
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
        self.phoneTemp = phone!*/
        
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
