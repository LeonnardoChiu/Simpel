//
//  PaymentMethodViewController.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class PaymentMethodViewController: UIViewController {

    // MARK: - Variable
    
    // MARK: - IBOutlet
    @IBOutlet weak var paymentTableView: UITableView! {
        didSet {
            paymentTableView.tableFooterView = UIView(frame: .zero)
        }
    }

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
               if cell.accessoryType == .checkmark {
                   cell.accessoryType = .none
               } else {
                   cell.accessoryType = .checkmark
               }
        }
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
               if cell.accessoryType == .checkmark {
                   cell.accessoryType = .none
               } else {
                   cell.accessoryType = .checkmark
               }
        }
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
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
