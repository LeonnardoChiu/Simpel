//
//  DetailBarangViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class DetailBarangViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    let database = CKContainer.default().publicCloudDatabase
    var detailBarangCkrecord: CKRecord!
    @IBOutlet weak var namaBarangDetailLabel: UILabel!
    @IBOutlet weak var gambar: UIImageView!
    var img: CKAsset?
    
    var namaCell: [String] = ["Barcode", "Category","Company Name", "Stock Quantity"]
    var isiCell:[String] = []
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    func appendIsiCell(){
        isiCell.append(detailBarangCkrecord.value(forKey: "Barcode") as! String)
        isiCell.append(detailBarangCkrecord.value(forKey: "Category") as! String)
        isiCell.append(detailBarangCkrecord.value(forKey: "Distributor") as! String)
        isiCell.append(String(detailBarangCkrecord.value(forKey: "Stock") as! Int))
    
    }
    func showImage(){
        
        img = (detailBarangCkrecord.value(forKey: "Images") as? [CKAsset])?.first
        if let image = img, let url = image.fileURL, let data = NSData(contentsOf: url) {
            self.gambar.image = UIImage(data: data as Data)
            self.gambar.contentMode = .scaleAspectFill
        } else {


        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        appendIsiCell()
        namaBarangDetailLabel.text = detailBarangCkrecord.value(forKey: "NameProduct") as! String
        print(detailBarangCkrecord.value(forKey: "Category"))
        
        showImage()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
              return namaCell.count
        }
        
      return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Price List"
        }
        return ""
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cellDetail = tableView.dequeueReusableCell(withIdentifier: "detail", for: indexPath) as! DetailBarangCell
        let cellPrice = tableView.dequeueReusableCell(withIdentifier: "price", for: indexPath) as! DetailPriceListCell
        
        
        if indexPath.section == 0{
            cellDetail.namaCellDetailLabel.text = namaCell[indexPath.row]
            cellDetail.isiCellDetailLabel.text = isiCell[indexPath.row]
            return cellDetail
        }
        if indexPath.section == 1 {
            let price = detailBarangCkrecord.value(forKey: "Price") as! Int
            cellPrice.Pricelist.text = price.commaRepresentation
            cellPrice.unitcelLabel.text = detailBarangCkrecord.value(forKey: "Unit") as! String
            return cellPrice
        }
        
        return cellDetail
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

class DetailBarangCell:UITableViewCell{
    @IBOutlet weak var namaCellDetailLabel: UILabel!
    @IBOutlet weak var isiCellDetailLabel: UILabel!
}

class DetailPriceListCell: UITableViewCell {
    @IBOutlet weak var Pricelist: UILabel!
    @IBOutlet weak var unitcelLabel: UILabel!
    
}


