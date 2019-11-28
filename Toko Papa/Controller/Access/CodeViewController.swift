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
    var tokoCode: Toko?
    let database = CKContainer.default().publicCloudDatabase
    var data = [CKRecord]()
    @IBOutlet weak var codeGen: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        codeGen.text = "\(tokoCode!.uniqcode!/100000) "
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
