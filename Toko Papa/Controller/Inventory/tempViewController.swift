//
//  AddInventoryViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 04/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class tempViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    var satuanSekarang: [String?] = ["Unit","Unit"]

    var placeHolderTextField: [String] = ["Barcode", "Nama Produk", "Kategori", "Distributor", "Stok"]
    let database = CKContainer.default().publicCloudDatabase
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    var images:[UIImage] = [UIImage]()
    var collection:UICollectionView!
    let imageWidth = 130
    let imageHeight = 130
    let buttonSize = 25
    var cekSatuanBarang: Int?
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var viewForCollectionView: UICollectionView!
    override func viewDidLoad() {
          super.viewDidLoad()
          self.tableView.delegate = self
          self.tableView.dataSource = self
          initCollection()

          // Do any additional setup after loading the view.
      }
      
      override func viewWillAppear(_ animated: Bool) {
            print(satuanSekarang)
            self.tableView.reloadData()
      }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }else if section == 1 {
            return "Price List"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return satuanSekarang.count
        }else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellPrice = tableView.dequeueReusableCell(withIdentifier: "price", for: indexPath) as! TambahBarangCellPriceList
        
        let cellBiasa = tableView.dequeueReusableCell(withIdentifier: "biasa", for: indexPath) as! TambahBarangCellBiasa
        
        let cellplus = tableView.dequeueReusableCell(withIdentifier: "plus", for: indexPath) as! TambahBarangCellPlus
        
        let cells = UITableViewCell()
        switch indexPath.section {
        case 0:
                cellBiasa.tambahBarangTextField.placeholder = placeHolderTextField[indexPath.row]
                return cellBiasa
        case 1:
            var temp = satuanSekarang.count - 1 // 2
            if indexPath.row >= 0 && indexPath.row < temp  {
                cellPrice.tambahBarangTextField.placeholder = "Harga per"
                cellPrice.PieceLabel.text = satuanSekarang[indexPath.row]
                cellPrice.accessoryType = .disclosureIndicator
                cellPrice.MinesImage.isHidden = true
                if indexPath.row != 0{
                    cellPrice.MinesImage.isHidden = false
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                   cellPrice.MinesImage.isUserInteractionEnabled = true
                   cellPrice.MinesImage.addGestureRecognizer(tapGestureRecognizer)
                }
                return cellPrice
            }
            if indexPath.row == temp{ // 2
               
                return cellplus
            }
        default:
             return cells
        }
        return cells
    }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        satuanSekarang.remove(at: 1)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            var temp = satuanSekarang.count - 1
            if indexPath.row >= 0 && indexPath.row < temp  {
                cekSatuanBarang = indexPath.row
                performSegue(withIdentifier: "satuan", sender: satuanSekarang[cekSatuanBarang!])
            }
            if indexPath.row == temp{
                satuanSekarang.append("Unit")
                self.tableView.reloadData()
            }
        }
        
        
         tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "satuan"{
            guard let vc = segue.destination as? SatuanBarangTableViewController else { return }
            if let satuan = satuanSekarang[cekSatuanBarang!]{
                vc.selectedUnit = satuan
            }
            
        }
    }
    
    @IBAction func unwindFromSatuanVC(segue: UIStoryboardSegue){
        guard let satuanVC = segue.source as? SatuanBarangTableViewController else { return }
        self.satuanSekarang[cekSatuanBarang!] = satuanVC.selectedUnit!
    }
    
    
    
    
    
  
    
  
    
    func saveToCloud(Barcode: String, Name: String, Category:String, Distributor:String, Stock:Int, Price: Int){
            let NewNote = CKRecord(recordType: "Inventory")//ini buat data base baru
            NewNote.setValue(Barcode, forKey: "Barcode")//ini ke tablenya
            NewNote.setValue(Category, forKey: "Category")
            NewNote.setValue(Distributor, forKey: "Distributor")
            NewNote.setValue(Name, forKey: "NameProduct")
            NewNote.setValue(Price, forKey: "Price")
            NewNote.setValue(Stock, forKey: "Stock")
        
         database.save(NewNote) { (record, error) in
             print(error)
             guard record != nil else { return}
             print("savaedddd")
         }
    }

    @IBAction func doneButton(_ sender: Any) {
//        self.saveToCloud(Barcode: barcode.text!, Name: nameProduct.text!, Category: category.text!, Distributor: distributorName.text!, Stock: Int(stock.text!)!, Price: Int(price.text!)!)
    }
    
    func collectionView(_ collection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 3{
            while(images.count > 3){
                images.popLast()
            }
        }
        return images.count
    }
    
    func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let tempimage = images[indexPath.row]
        let imageView = UIImageView(image: tempimage)
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight);
        cell.addSubview(imageView)
        let button = UIButton(frame: CGRect(x: (imageWidth-buttonSize), y: 0, width: buttonSize, height: buttonSize))
        button.backgroundColor = .red
        button.setTitle("x", for: .normal)
        switch indexPath.row{
        case 0:
            button.addTarget(self, action: #selector(buttonAction0), for: .touchUpInside)
            cell.addSubview(button)
            break
        case 1:
            button.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
            cell.addSubview(button)
            break
        case 2:
            button.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
            cell.addSubview(button)
            break
        default:
            print("error")
            break
        }
        return cell
    }
    
    @objc func buttonAction0(sender: UIButton!) {
        images.remove(at: 0)
        self.collection.reloadData()
        checkImagesCount()
    }
    @objc func buttonAction1(sender: UIButton!) {
        images.remove(at: 1)
        self.collection.reloadData()
        checkImagesCount()
    }
    @objc func buttonAction2(sender: UIButton!) {
        images.remove(at: 2)
        self.collection.reloadData()
        checkImagesCount()
    }
    
    
    func checkImagesCount(){
        if images.count < 3{
            self.addImageButton.isHidden = false
            
        }else{
            self.addImageButton.isHidden = true
        }
    }
    
    
    
    func collectionView(_ collection: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: imageWidth, height: imageHeight)
        return size
    }
    func initCollection(){
        viewForCollectionView.frame =  CGRect(x: 0 , y: 0, width: self.view.frame.width, height: CGFloat(imageHeight))
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: imageWidth, height: imageHeight)
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: self.viewForCollectionView.frame, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.viewForCollectionView.addSubview(collection)
    }
    
    @IBAction func addPhotoButton(_ sender: Any) {
        if images.count < 3{
            ImagePickerManager().pickImage(self){ image in
                self.images.append(image)
                //                print(image.)
                self.collection.reloadData()
                self.checkImagesCount()
            }
        }
        
    }
    
    

}
