//
//  AddInventoryViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 04/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class AddInventoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
   
    
    var satuanSekarang: String? = "Unit"
    var placeHolderTextField: [String] = ["Barcode", "Nama Produk", "Kategori", "Distributor", "Stok"]
    let database = CKContainer.default().publicCloudDatabase
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    
    var images:[UIImage] = [UIImage]()
    var collection:UICollectionView!
    let imageWidth = 160
    let imageHeight = 195
    let buttonSize = 25
    var cekSatuanBarang: Int?
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var viewForCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        initCollection()
        self.collection.isHidden = true
       
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
            return "Daftar Harga"
        }
        return ""
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
                if indexPath.row == 4 {
                    cellBiasa.tambahBarangTextField.keyboardType = .decimalPad
                }
                return cellBiasa
        case 1:
                cellPrice.tambahBarangTextField.placeholder = "Harga per"
                cellPrice.tambahBarangTextField.keyboardType = .decimalPad
                cellPrice.PieceLabel.text = satuanSekarang
                cellPrice.accessoryType = .disclosureIndicator
                return cellPrice
        default:
             return cells
        }
        return cells
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "satuan", sender: 0)
        }
        
        
         tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "satuan"{
            guard let vc = segue.destination as? SatuanBarangTableViewController else { return }
            if let satuan = satuanSekarang{
                vc.selectedUnit = satuan
                vc.pemelihVC = sender as! Int
            }
            
        }
    }
    
    @IBAction func unwindFromSatuanVCTambahBarang(segue: UIStoryboardSegue){
        guard let satuanVC = segue.source as? SatuanBarangTableViewController else { return }
        self.satuanSekarang = satuanVC.selectedUnit!
    }
    
    
    
    
    
  
    
  
    
    func saveToCloud(Barcode: String, Name: String, Category:String, Distributor:String, Stock:Int, Price: Int, image:[UIImage],unit:String){
            let NewNote = CKRecord(recordType: "Inventory")//ini buat data base baru
            NewNote.setValue(Barcode, forKey: "Barcode")//ini ke tablenya
            NewNote.setValue(Category, forKey: "Category")
            NewNote.setValue(Distributor, forKey: "Distributor")
            NewNote.setValue(Name, forKey: "NameProduct")
            NewNote.setValue(Price, forKey: "Price")
            NewNote.setValue(Stock, forKey: "Stock")
        
            var imageAsset: [CKAsset] = []
               
            for gambar in image {
                let resizedImage = gambar.resizedTo1MB()
                var asset = CKAsset(fileURL: getUrl(resizedImage!)!)
                imageAsset.append(asset)
                print("aaa")
            }
       
            NewNote.setValue(imageAsset, forKey: "Images")
            NewNote.setValue(unit, forKey: "Unit")
            NewNote.setValue(1, forKey: "Version")
        
         database.save(NewNote) { (record, error) in
             print(error)
             guard record != nil else { return}
             print("savaedddd")
         }
    }
    
    func getUrl(_ imagess: UIImage) -> URL?{
        let data = imagess.pngData(); // UIImage -> NSData, see also UIImageJPEGRepresentation
        let url = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".dat")
        do {
            try data!.write(to:url!, options: [])
            
        } catch let e as NSError {
            print("Error! \(e)");
            return nil
        }
        
        return url
    }
    
    func tambahBarang(){
        guard let barcode = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let name = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let category = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let distributor = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let stock = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let price = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TambahBarangCellPriceList else {return}
        
         self.saveToCloud(Barcode: (barcode.tambahBarangTextField.text)!, Name: (name.tambahBarangTextField.text)!, Category: (category.tambahBarangTextField.text)!, Distributor: (distributor.tambahBarangTextField.text)!, Stock: Int((stock.tambahBarangTextField.text)!)!, Price: Int((price.tambahBarangTextField.text)!)!, image: images,unit: satuanSekarang!)
    }

    @IBAction func doneButton(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
        
        
        tambahBarang()
        
        let ok = UIAlertAction(title: "OK", style: .default) { ACTION in
            self.performSegue(withIdentifier: "backToInventory", sender: nil)
        }
      alert = UIAlertController(title: "Sukses", message: "Berhasil Menambah barang", preferredStyle: .alert)
      alert.addAction(ok)
      present(alert, animated: true, completion: nil)
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
        if images.count < 1{
            self.addImageButton.isHidden = false
              self.collection.isHidden = true
            
        }else{
            self.addImageButton.isHidden = true
            self.collection.isHidden = false
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

class TambahBarangCellPriceList: UITableViewCell{
    
    @IBOutlet weak var tambahBarangTextField: UITextField!
    @IBOutlet weak var PieceLabel: UILabel!
}


class TambahBarangCellBiasa: UITableViewCell{
    
    @IBOutlet weak var tambahBarangTextField: UITextField!
}


