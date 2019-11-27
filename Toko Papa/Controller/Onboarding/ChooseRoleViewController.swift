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
    var modelPemilik: People?
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
        let gestureOwner: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Owner))
        // or declare like this
        let gestureKaryawan: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Karyawan))

        
        self.ownerView.addGestureRecognizer(gestureOwner)
        self.karyawanView.addGestureRecognizer(gestureKaryawan)

    }
    
    
    
    @objc func Owner() {
       performSegue(withIdentifier: "ownerToko", sender: nil)
    }
    
    @objc func Karyawan() {
        print("AAAAA")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "ownerToko"{
            guard let vc = segue.destination as? TokoViewController else { return }
                vc.modelPemilik = modelPemilik
        }
    }
    
    // MARK: - View will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
