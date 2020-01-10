//
//  OnboardingViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 25/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit
import AuthenticationServices

class OnboardingViewController: UIViewController {

    // MARK: - Variable.
    
    /// Database
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    var people: [People] = []
    var model: People?
    var user: User?
    var image: CKAsset?
    
    var loginStatus = UserDefaults.standard.bool(forKey: "userLogin")
    var cek = false

    var textfieldpassword: String?
    
    @IBOutlet weak var forDeveloperButton: UIButton!
    
    // MARK: - IBOutlet list
    @IBOutlet weak var signInAppleBtn: UIStackView!
    
    @IBAction func loginBtn(_ sender: UIButton) {
       
    }
    @IBAction func unwindFromLoginVC(segue: UIStoryboardSegue){
        guard let _ = segue.source as? RegisterViewController else { return }
        
    }
    
    
    
   
    
    var counter = 0
    var timer = Timer()
     var appleId = ""
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: USER DEFAULT
//        loginStatus = false
          cek = false
        print(loginStatus)
//        forDeveloperButton.isHidden = true
       
        if let appleID = UserDefaults.standard.string(forKey: "appleId") {
           
        }else{
           
        }
        if loginStatus == false {
             initAppleSignInButton()
        }
        else{
            appleId = UserDefaults.standard.string(forKey: "appleId")!
            print(appleId)
            self.QueryDatabase(appleid: appleId) { (status) in
                DispatchQueue.main.sync {
                if let vc: MainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainTabBarController {
                    vc.peopleMaintab = self.people
                    vc.modelPeople = self.model
                    vc.appleid = self.appleId
                    //navigationController?.setNavigationBarHidden(false, animated: true)
                    let appDelegate = UIApplication.shared.windows
                    appDelegate.first?.rootViewController = vc
                    self.present(vc, animated: true, completion: nil)
                    
                }
                }
            }
           
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Init data model
    func initDataModel() {
        people.removeAll()
        for countData in data {
            let id = countData.recordID
            let appleid = countData.value(forKey: "AppleID") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let roleee = countData.value(forKey: "role") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
            
            
            
            people.append(People(id: id, appleid: appleid, firstName: firstName, rolee: roleee, toko: tokoID))
        }
    }
    
    // MARK: - obj function untuk nampilin data Query Database
    @objc func QueryDatabase(appleid: String, completion: @escaping (Bool)-> Void) {
           let query = CKQuery(recordType: "Profile", predicate: NSPredicate(format: "AppleID == %@", appleid))
        
           database.perform(query, inZoneWith: nil) { (record, _) in
               guard let record = record else { return }
               //let sortedRecord = record.sorted(by: {$0.creationDate! > $1.creationDate!})
               self.data = record
               self.initDataModel()
               for i in self.people{
                   print(i.appleID)
                   print(i.firstName)
              }
               print("Total Employee dalam database : \(self.data.count)")
        
            completion(true)
           }
       }
    
    // MARK: - Function Check Form
    func checkForm(user: User) {
        self.QueryDatabase(appleid: user.id) {
            status in
            if self.people.count == 0{
                 DispatchQueue.main.async {
                 self.performSegue(withIdentifier: "toRegister", sender: user)
                }
            }else{
                self.model = self.people.first
                if self.model?.role == "-" || self.model?.tokoID == "-" {
                     DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toChooseRole", sender: nil)
                    }
                }else{
                    /// ke main storyboard
                    DispatchQueue.main.sync {
                        if let vc: MainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainTabBarController {
                                vc.peopleMaintab = self.people
                                vc.modelPeople = self.model
                                vc.appleid = ""
                                //navigationController?.setNavigationBarHidden(false, animated: true)
                                let appDelegate = UIApplication.shared.windows
                                appDelegate.first?.rootViewController = vc
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                            
                        self.navigationController?.setNavigationBarHidden(false, animated: true)
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Apple sign in button init view
    func initAppleSignInButton() {
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        /// add apple sign button ke dalam stack view
        self.signInAppleBtn.addArrangedSubview(authorizationButton)
    }
    /// objc selector untuk login by apple ID
    @objc func didTapSignInButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    // MARK: - Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseRole" {
            guard let vc = segue.destination as? ChooseRoleViewController else { return }
                vc.modelPemilik = model
            
        }
        
        if let regVC = segue.destination as? RegisterViewController, let user = sender as? User {
            regVC.user = user
            regVC.people = people
            regVC.firstName = user.firstName
            regVC.lastName = user.lastName
            regVC.email = user.email
            regVC.id = user.id
        }
    }

    // MARK: for developer
    @IBAction func forDeveloperPurpose(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
        alert = UIAlertController(title: "Password", message: "Input password Devolper", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Masukan Password"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
            textField.tag = 1
            textField.delegate = self
        }
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "OK", style: .default) { ACTION in
            
            if self.textfieldpassword == "1234"{
                self.QueryDatabase(appleid: "000199.53be12a7a93d4d749a7d907e94e99b6a.0307") { (status) in
                    self.model = self.people.first
                    DispatchQueue.main.sync {
                        if let vc: MainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainTabBarController {
                        vc.peopleMaintab = self.people
                        vc.modelPeople = self.model
                        vc.appleid = ""
                        //navigationController?.setNavigationBarHidden(false, animated: true)
                        let appDelegate = UIApplication.shared.windows
                        appDelegate.first?.rootViewController = vc
                        self.present(vc, animated: true, completion: nil)
                        }
                    }

                
                    
                }
            }else{
                var alert2: UIAlertController = UIAlertController()
                alert2 = UIAlertController(title: "Password Salah", message: "Kamu bukan developer", preferredStyle: .alert)
                let cancel2 = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert2.addAction(cancel2)
                self.present(alert2, animated: true, completion: nil)
            }
        
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    
    }
}





// MARK: - EXTENSION
extension OnboardingViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential :
            let user = User(credentials: credentials)
            checkForm(user: user)
            break
        default:
            break
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Gagal login")
    }
}

extension OnboardingViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension OnboardingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textFIeldRow = textField.tag
        
        if textFIeldRow == 1 {
            textfieldpassword = textField.text
            print(textfieldpassword)
        }
    }
}
