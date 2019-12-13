//
//  MainTabBarController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 26/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class MainTabBarController: UITabBarController {

    var modelPeople: People?
    var peopleMaintab: [People] = []
    var image: CKAsset?
    var appleid: String?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
//        UserDefaults.standard.set("\(modelPeople?.Id)", forKey: "id")
//        UserDefaults.standard.set(modelPeople?.appleID, forKey: "appleId")
//        UserDefaults.standard.set(modelPeople?.tokoID, forKey: "tokoId")
//        UserDefaults.standard.set(modelPeople?.email, forKey: "email")
//        UserDefaults.standard.set(modelPeople?.firstName, forKey: "firstName")
//        UserDefaults.standard.set(modelPeople?.lastName, forKey: "lastName")
//        UserDefaults.standard.set(modelPeople?.phone, forKey: "phone")
//        UserDefaults.standard.set(modelPeople?.role, forKey: "role")
        UserDefaults.standard.set(true, forKey: "userLogin")
       
        if appleid != ""{
            checkForm()
        }else{
             UserDefaults.standard.set(modelPeople!.appleID, forKey: "appleId")
        }
       
    }
    
    
    
    
    
    func checkForm() {
        var cek = false
        print("hai : \(appleid!)")
        print("bnsgt ", peopleMaintab.count)
        for ppl in peopleMaintab{
            if ppl.appleID == appleid!{
                cek = true
                modelPeople = ppl
                break
            }
        }
        
        if cek == true{
            
            print("ada model")
        }else{
             
            print("gak ada model")
        }
    }

}
