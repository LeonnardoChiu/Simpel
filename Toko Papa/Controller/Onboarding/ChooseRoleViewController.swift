//
//  ChooseRoleViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 25/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class ChooseRoleViewController: UIViewController {

    
    // MARK: - Variable
    
    /// database
    let database = CKContainer.default().publicCloudDatabase
    var data: CKRecord!
    
    // MARK: - IBOutlet
    @IBOutlet weak var ownerView: UIView! {
        didSet {
            ownerView.layer.shadowRadius = 10
        }
    }
    
    @IBOutlet weak var karyawanView: UIView!
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        // or declare like this
        let gesture2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))

        
        self.ownerView.addGestureRecognizer(gesture)
        self.karyawanView.addGestureRecognizer(gesture2)

    }
    
    
    
    @objc func tap() {
        print("AAAAA")
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
