//
//  PaymentMethodViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class PaymentMethodViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var paymentTableView: UITableView!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - add xib pakai UINib
        let nibPaymentMethod = UINib(nibName: "PaymentMethodCell", bundle: nil)
        paymentTableView.register(nibPaymentMethod, forCellReuseIdentifier: "PaymentMethodCell")
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

extension PaymentMethodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paymentCell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodCell") as! PaymentMethodCell
        
        if indexPath.row == 0 {
            paymentCell.cashLbl.text = "Cash"
        }
        if indexPath.row == 1 {
            paymentCell.cashLbl.text = "Cashless"

        }
        
        return paymentCell
    }
    
    
}
