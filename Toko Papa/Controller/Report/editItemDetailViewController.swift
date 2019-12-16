
import UIKit

class editItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var itemDetailImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var itemName = ""
    var itemChanged = "Harga"
    var itemValueChanged = "200000 to 250000"
    var itemReason = "disuruh boss"
    var editorName = "Budi"
    
    var modelPemilik: People?
    var editBarang: [EditBarang] = []
    var inventory: [Inventory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for item in inventory {
            if editBarang[0].inventoryID == item.Id.recordName {
                itemDetailImage.image = item.imageItem
            }
        }
        print(editBarang[0].kategori)
        print(editBarang[0].alasan)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editItemDetailTableCellID", for: indexPath)
        let itemLabel = cell.contentView.viewWithTag(1) as! UILabel
        let valueLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        if indexPath == [0,0] {
            itemLabel.text = "Nama"
            for item in inventory {
                if editBarang[0].inventoryID == item.Id.recordName {
                    valueLabel.text = item.namaItem
                }
            }
        }
        else if indexPath == [0,1] {
            itemLabel.text = editBarang[0].kategori
            valueLabel.text = editBarang[0].value
        }
        else if indexPath == [0,2] {
            itemLabel.text = "Alasan"
            valueLabel.text = editBarang[0].alasan
        }
        
        return cell
    }

}
