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
    var placeHolders: [String] = ["Nama Lengkap"]
    var isiCellforRow: [String] = []
    var user: User?
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var modelRegister: People?
    var people: [People] = []
    var image: CKAsset?
    var images = UIImage()
    var roleTemp: String = ""
    var usernameTemp = ""
    var passwordTemp = ""
    var namaDepanTemp = ""

    
    var namaDepanValidTemp = ""
    var cek = false
     var alert2: UIAlertController = UIAlertController()
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
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
    var counter = 0
    var timer = Timer()

    @IBAction func doneBtn(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
       
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.selesai.isEnabled = true
            
            self.alert2 = UIAlertController(title: "mohon menunggu", message: "tunggu beberapa detik", preferredStyle: .alert)
          
            self.present(self.alert2, animated: true, completion: nil)
            self.cek = false
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
            //initDataModel()
        }
        if cek == true {
            counter = 0
            timer.invalidate()
            //performSegue(withIdentifier: "backtoLogin", sender: nil)
            alert2.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "toRole", sender: nil)
        }
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        isiCellforRow.append(user!.firstName)
        navigationController?.setNavigationBarHidden(false, animated: true)
        namaDepanTemp = user!.firstName
        enabledDoneButton()
    }
    
    // MARK: - Function
    
    
    // MARK: - objc untuk profile image
    
    
    // MARK: - Save to cloud function
    func saveToCloud(AppleID: String, firstName: String) {
        print("mulai save")
        let record = CKRecord(recordType: "Profile")
        record.setValue(AppleID, forKey: "AppleID")
        record.setValue(firstName, forKey: "firstName")
        record.setValue("-", forKey: "role")
        
        record.setValue("-", forKey: "TokoID")
        initDataModel()
        database.save(record) { (record, _) in
            guard record != nil else { return }
            print("Data saved to Cloud!")
            self.cek = true
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
        //let role = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as? RegisterViewCel
        
        self.saveToCloud(AppleID: user!.id, firstName: firstName!.textField.text!)
    }
    
    func initDataModel() {
        let firstName = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RegisterViewCell
        
        //model
        let tokoIDReference = CKRecord.ID(recordName: "-")
        modelRegister = People(id: tokoIDReference, appleid: user!.id, firstName: firstName!.textField.text!, rolee: "-", toko: "-")
        
    }
    
    func enabledDoneButton() {
        if namaDepanValidTemp == "" {
            doneButton.isEnabled = false
        }
        else{
            doneButton.isEnabled = true
        }
    }
    
    // MARK: - Unwind
    @IBAction func unwindFromRole(_ unwindSegue: UIStoryboardSegue) {
        guard let roleVC = unwindSegue.source as? RoleViewController else { return }
        
        self.roleTemp = roleVC.selectedRole
         let indexPath = IndexPath(item: 4, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       
        
        if segue.identifier == "toRole" {
             guard let vc = segue.destination as? ChooseRoleViewController else { return }
             vc.modelPemilik = modelRegister
            vc.people = people
        }
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
    
    // MARK: - Cell for row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell") as! RegisterViewCell
        
        cell.textField.placeholder = placeHolders[indexPath.row]
//        cell.textField.text = isiCellforRow[indexPath.row]
        if indexPath.row == 3 {
            cell.textField.keyboardType = .numberPad
        }
        cell.textField.tag = indexPath.row
        return cell
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textFieldRow = textField.tag
        
        if textFieldRow == 0 {
            if textField.text == "" {
                textField.attributedPlaceholder = NSAttributedString(string: "Nama harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemRed])
            }
            namaDepanValidTemp = textField.text!
        }
        
        print(namaDepanValidTemp)
        
        enabledDoneButton()

    }
}
