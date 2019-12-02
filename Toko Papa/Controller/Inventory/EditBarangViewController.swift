//
//  EditBarangViewController.swift
//  Toko Papa
//
//  Created by Louis  Valen on 13/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class EditBarangViewController: UIViewController{
    var satuanSekarang: String? = "Unit"
    var editItem: Inventory?
    var barcodeTemp = ""
    var namaTemp = ""
    var kategoriTemp = ""
    var distributorTemp = ""
    var stokTemp:Int? = 0
    var hargaTemp:Int?
    var placeHolderTextField: [String] = ["Barcode", "Nama Produk", "Kategori", "Distributor", "Stok"]
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }
    let database = CKContainer.default().publicCloudDatabase
    var img: CKAsset?
    var images:[UIImage] = [UIImage]()
    var collection:UICollectionView!
    let imageWidth = 160
    let imageHeight = 195
    let buttonSize = 25
    var editCKrecord: CKRecord!
    var kategoriSekarang: String?
    var isiTextField: [String] = []
    var data = [CKRecord]()
    var modelPemilik: People?
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var viewForCollectionView: UICollectionView!
    @IBOutlet weak var doneBtnOutlet: UIBarButtonItem!
    var barcode: QRData?
    func appendTextField(){
        /*isiTextField.append(editCKrecord.value(forKey: "Barcode") as! String)
        isiTextField.append(editCKrecord.value(forKey: "NameProduct") as! String)
        isiTextField.append(editCKrecord.value(forKey: "Category") as! String)
        isiTextField.append(editCKrecord.value(forKey: "Distributor") as! String)
        isiTextField.append(String(editCKrecord.value(forKey: "Stock") as! Int))
        */
        isiTextField.append(editItem!.barcode)
        isiTextField.append(editItem!.namaItem)
        isiTextField.append(editItem!.category)
        isiTextField.append(editItem!.distributor)
        isiTextField.append(String(editItem!.stock))
    
    }
    func showImage(){
//           img = (editCKrecord.value(forKey: "Images") as? [CKAsset])?.first
        img = editItem?.imageItem as? CKAsset
        if let image = img, let url = image.fileURL, let data = NSData(contentsOf: url) {
        images.append(UIImage(data: data as Data) as! UIImage)
            self.collection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QueryDatabase()
        self.hideKeyboardWhenTappedAround() 
        self.tableView.delegate = self
        self.tableView.dataSource = self
        initCollection()
        appendTextField()
        
        
        kategoriSekarang = editItem?.category
        images.append(editItem!.imageItem!)
        self.addImageButton.isHidden = true
        
        barcodeTemp = isiTextField[0]
        namaTemp = isiTextField[1]
        kategoriTemp = isiTextField[2]
        distributorTemp = isiTextField[3]
        stokTemp = Int(isiTextField[4])
        hargaTemp = editItem?.price
        
        enabledDoneButton()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        print(satuanSekarang)
        //self.tableView.reloadData()
        
    }
    
    func enabledDoneButton() {
        if barcodeTemp == "" || namaTemp == "" || kategoriTemp == "" || distributorTemp == "" || stokTemp == 0 || hargaTemp == 0 || images.count < 1 {
            doneBtnOutlet.isEnabled = false
        }
        else{
            doneBtnOutlet.isEnabled = true
        }
    }


    @IBAction func unwindFromSatuanVCEdit(segue: UIStoryboardSegue){
        guard let satuanVC = segue.source as? SatuanBarangTableViewController else { return }
        self.satuanSekarang = satuanVC.selectedUnit!
        hargaTemp = satuanVC.hargaTempSatuan
        
       let indexPath = IndexPath(item: 0, section: 1)
       tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
    @IBAction func unwindToKategoriVcEdit(segue: UIStoryboardSegue) {
        guard let kategoriVC = segue.source as? KategoriTableViewController else {return}
        self.kategoriSekarang = kategoriVC.selectedKategori
        kategoriTemp = kategoriVC.selectedKategori!
     
        let indexPath = IndexPath(item: 2, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func unwindFromKBarcode(segue: UIStoryboardSegue){
        guard let barcodeVC = segue.source as? BarcodeViewController else { return }
        self.barcode = barcodeVC.qrData
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    
    @IBAction func doneEditButton(_ sender: Any) {
        var alert: UIAlertController = UIAlertController()
        updateBarang()
        let ok = UIAlertAction(title: "OK", style: .default) { ACTION in
              self.performSegue(withIdentifier: "backToInventory", sender: nil)
          }
        alert = UIAlertController(title: "Sukses", message: "Berhasil Mengubah biograhpy barang", preferredStyle: .alert)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
   
    @objc func QueryDatabase(){
        let query = CKQuery(recordType: "Inventory", predicate: NSPredicate(value: true))
    
        //let sortDesc = NSSortDescriptor(key: filterString!, ascending: sorting)
        //query.sortDescriptors = [sortDesc]
        database.perform(query, inZoneWith: nil) { (record, _) in
            guard let record = record else {return}
                
            self.data = record
            /// append ke model
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UPDATE TO CLOUDE
    func updateToCloud(Barcode: String, Name: String, Category:String, Distributor:String, Stock:Int, Price: Int, image:[UIImage],unit:String, model:Inventory){
            var editNote: CKRecord?
            
            for edit in data{
                if model.Id.recordName == edit.recordID.recordName{
                editNote = edit
                    print("ASOOO")
                    print(edit.value(forKey: "NameProduct"))
                break
                }
            }
       
            
            editNote?.setValue(Barcode, forKey: "Barcode")//ini ke tablenya
            editNote?.setValue(Category, forKey: "Category")
            editNote?.setValue(Distributor, forKey: "Distributor")
            editNote?.setValue(Name, forKey: "NameProduct")
            editNote?.setValue(Price, forKey: "Price")
            editNote?.setValue(Stock, forKey: "Stock")
        
            var imageAsset: [CKAsset] = []
               
            for gambar in image {
                let resizedImage = gambar.resizedTo1MB()
                var asset = CKAsset(fileURL: getUrl(resizedImage!)!)
                imageAsset.append(asset)
                print("aaa")
            }
        var version = model.version + 1
            version = version + 1
            editNote?.setValue(imageAsset, forKey: "Images")
            editNote?.setValue(unit, forKey: "Unit")
            editNote?.setValue(version, forKey: "Version")
        
        
        database.save(editNote!) { (record, error) in
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
    
    func updateBarang(){
        guard let barcode = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let name = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? TambahBarangCellBiasa else {return}
        
         guard let distributor = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let stock = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? TambahBarangCellBiasa else {return}
         guard let price = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TambahBarangCellPriceList else {return}
        
        self.updateToCloud(Barcode: (barcode.tambahBarangTextField.text)!, Name: (name.tambahBarangTextField.text)!, Category: kategoriSekarang!, Distributor: (distributor.tambahBarangTextField.text)!, Stock: Int((stock.tambahBarangTextField.text)!)!, Price: Int((price.tambahBarangTextField.text)!)!, image: images,unit: satuanSekarang!, model: editItem!)
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

extension EditBarangViewController: UITableViewDelegate,UITableViewDataSource{
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
                cellBiasa.tambahBarangTextField.text = isiTextField[indexPath.row]
                if indexPath.row == 0 {
                    if barcode != nil{
                        cellBiasa.tambahBarangTextField.text = barcode?.codeString
                    }
                }
                if indexPath.row != 0 {
                    cellBiasa.barcodeScannerButton.isHidden = true
                }
                if indexPath.row == 2 {
                    cellBiasa.accessoryType = .disclosureIndicator
                     if kategoriSekarang == "Kategori"{
                          cellBiasa.textLabel?.textColor = .systemGray3
                      }
                    cellBiasa.textLabel?.font = UIFont.systemFont(ofSize: 14)
                    cellBiasa.textLabel!.text = kategoriSekarang
                    cellBiasa.tambahBarangTextField.isHidden = true
                }
                if indexPath.row == 4 {
                    cellBiasa.tambahBarangTextField.keyboardType = .decimalPad
                }
                cellBiasa.tambahBarangTextField.tag = indexPath.row
                return cellBiasa
        case 1:
                cellPrice.tambahBarangTextField.placeholder = "Harga per"
                cellPrice.tambahBarangTextField.text = "\(hargaTemp!)"
                cellPrice.tambahBarangTextField.keyboardType = .decimalPad
                cellPrice.PieceLabel.text = satuanSekarang
                cellPrice.accessoryType = .disclosureIndicator
                cellPrice.tambahBarangTextField.tag = 5
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
            return "Daftar Harga"
        }
        return ""
    }
    //MARK: -prepare segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
                performSegue(withIdentifier: "satuan", sender: 1)
            }
        if indexPath.section == 0, indexPath.row == 2 {
            performSegue(withIdentifier: "kategori", sender: 1)
        }
        
        tableView.deselectRow(at: IndexPath.init(row: indexPath.row, section: indexPath.section), animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "satuan"{
            guard let vc = segue.destination as? SatuanBarangTableViewController else { return }
            if let satuan = satuanSekarang{
                vc.selectedUnit = satuan
                vc.pemelihVC = sender as! Int
                vc.hargaTempSatuan = hargaTemp
                vc.modelPemilik = modelPemilik
            }
           
        }
        
        if segue.identifier == "kategori" {
            guard let vc = segue.destination as? KategoriTableViewController else {return}
            if let kategori = kategoriSekarang{
                vc.selectedKategori = kategori
                vc.pemilihVC = sender as! Int
                vc.modelPemilik = modelPemilik
            }
        }
    }
    
}


extension EditBarangViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
   
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
        enabledDoneButton()
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
        enabledDoneButton()
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
    
    
}

extension EditBarangViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let textFieldRow = textField.tag
        
        if textFieldRow == 0 {
            if textField.text == "" {
                textField.attributedPlaceholder = NSAttributedString(string: "Barcode harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            barcodeTemp = textField.text!
        }
        
        if textFieldRow == 1{
            if textField.text == "" {
                textField.attributedPlaceholder = NSAttributedString(string: "Nama produk harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            namaTemp = textField.text!
        }
        
        if textFieldRow == 2 {
            if textField.text == "" {
                textField.attributedPlaceholder = NSAttributedString(string: "Kategori harus dipilih", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            kategoriTemp = textField.text!
        }
        
        if textFieldRow == 3 {
            if textField.text == "" {
                textField.attributedPlaceholder = NSAttributedString(string: "Distributor harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
            distributorTemp = textField.text!
        }
        
        if textFieldRow == 4 {
            if textField.text == "" {
                textField.attributedPlaceholder = NSAttributedString(string: "stok harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                stokTemp = 0
            }
            else{
                stokTemp = Int(textField.text!)
            }
        }
        
        if textFieldRow == 5 {
            if textField.text == "" {
                textField.attributedPlaceholder = NSAttributedString(string: "Harga harus diisi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                hargaTemp = 0
            }
            else{
                hargaTemp = Int(textField.text!)
            }
        }
        print(barcodeTemp)
        print(namaTemp)
        print(kategoriTemp)
        print(distributorTemp)
        print("\(stokTemp!)")
        print("\(hargaTemp!)")
        enabledDoneButton()
    }
}
