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
    
    
    // MARK: - IBOutlet list
    @IBOutlet weak var signInAppleBtn: UIStackView!
    
    @IBAction func loginBtn(_ sender: UIButton) {
       
    }
    @IBAction func unwindFromLoginVC(segue: UIStoryboardSegue){
        guard let satuanVC = segue.source as? RegisterViewController else { return }
            QueryDatabase()
    }
    
    
    
    // MARK: - obj function untuk nampilin data Query Database
    @objc func QueryDatabase(){
        let query = CKQuery(recordType: "Profile", predicate: NSPredicate(value: true))
        
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
        }
        
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        initAppleSignInButton()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.QueryDatabase()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Init data model
    func initDataModel() {
        people.removeAll()
        for countData in data {
            let id = countData.recordID
            let appleid = countData.value(forKey: "AppleID") as! String
            let email = countData.value(forKey: "Email") as! String
            let firstName = countData.value(forKey: "firstName") as! String
            let lastName = countData.value(forKey: "lastName") as! String
            let phone = countData.value(forKey: "phoneNumber") as! String
            let roleee = countData.value(forKey: "role") as! String
            let tokoID = countData.value(forKey: "TokoID") as! String
            people.append(People(id: id, appleid: appleid, email: email,  firstName: firstName, lastName: lastName, phone: phone, rolee: roleee, toko: tokoID))
        }
    }
    
    // MARK: - Function Check Form
    func checkForm(user: User) {
        var cek = false
        print("hai : \(user.id)")
        for ppl in people{
            if ppl.appleID == user.id{
                cek = true
                model = ppl
                break
            }
        }
        
        if cek == true{
            
            if model?.role == "-" || model?.tokoID == "-" {
                performSegue(withIdentifier: "toChooseRole", sender: nil)
            }else{
                /// ke main storyboard
                if let vc: MainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainStoryboard") as? MainTabBarController {
                    vc.modelPeople = model
                    
                    //navigationController?.setNavigationBarHidden(false, animated: true)
                    let appDelegate = UIApplication.shared.windows
                    appDelegate.first?.rootViewController = vc
                    self.present(vc, animated: true, completion: nil)
                    
                }
                
            navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }else{
             
             // perform segue here
             performSegue(withIdentifier: "toRegister", sender: user)
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
            regVC.firstName = user.firstName
            regVC.lastName = user.lastName
            regVC.email = user.email
            
        }
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
