//
//  EditBarangViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit

class EditBarangViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var satuanSekarang: String? = "Unit"

    var placeHolderTextField: [String] = ["Barcode", "Nama Produk", "Kategori", "Distributor", "Stok"]

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 1
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellPrice = tableView.dequeueReusableCell(withIdentifier: "price", for: indexPath) as! TambahBarangCellPriceList
           
           let cellBiasa = tableView.dequeueReusableCell(withIdentifier: "biasa", for: indexPath) as! TambahBarangCellBiasa
           let cells = UITableViewCell()
           switch indexPath.section {
           case 0:
                   cellBiasa.tambahBarangTextField.placeholder = placeHolderTextField[indexPath.row]
                   return cellBiasa
           case 1:
                   cellPrice.tambahBarangTextField.placeholder = "Harga per"
                   cellPrice.PieceLabel.text = satuanSekarang
                   cellPrice.accessoryType = .disclosureIndicator
                   return cellPrice
           default:
                return cells
           }
           return cells
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }else if section == 1 {
            return "Price List"
        }
        return ""
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
