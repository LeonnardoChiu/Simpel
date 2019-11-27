//
//  CodeViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 27/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit
class CodeViewController: UIViewController {
    var modelPemilik: People?
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    @IBOutlet weak var codeGen: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        QueryDatabase()
        codeGen.text = data[0].value(forKey: "UniqCode") as! String
    }
    
    @objc func QueryDatabase(){
        let mainTabBar = self.tabBarController as! MainTabBarController
        modelPemilik = mainTabBar.modelPeople
        print(mainTabBar.modelPeople?.firstName)
        let tokoID = modelPemilik?.tokoID
        let query = CKQuery(recordType: "Toko", predicate: NSPredicate(format: "recordName == %@", tokoID!))
    
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.data = record
            /// append ke model
            print("jumlah barang : \(self.data.count)")
        }
      }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
