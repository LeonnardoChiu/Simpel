//
//  MainTabBarController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 26/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var modelPeople: People?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
        
        // Do any additional setup after loading the view.
    }

}
