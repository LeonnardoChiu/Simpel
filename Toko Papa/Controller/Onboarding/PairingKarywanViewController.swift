//
//  PairingKarywanViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 28/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class PairingKarywanViewController: UIViewController {
    var modelPemilik: People?
    var toko: [Toko] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("jumlah toko \(toko.count)")
        print("User name : \(modelPemilik?.username)")
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.x
    }
    */

}
