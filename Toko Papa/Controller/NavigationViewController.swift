//
//  NavigationViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 02/12/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)]
        self.navigationBar.tintColor = UIColor(displayP3Red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
        
    }

}
