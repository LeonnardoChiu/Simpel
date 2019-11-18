
import UIKit

class editItemDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var itemDetailImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var itemName = ""
    var itemChanged = "Harga"
    var itemValueChanged = "200000 to 250000"
    var itemReason = "disuruh boss"
    var editorName = "Budi"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editItemDetailTableCellID", for: indexPath)
        let itemLabel = cell.contentView.viewWithTag(1) as! UILabel
        let valueLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        if indexPath == [0,0] {
            itemLabel.text = itemName
            valueLabel.isHidden = true
        }
        else if indexPath == [1,0] {
            itemLabel.text = itemChanged
            valueLabel.text = itemValueChanged
            valueLabel.isHidden = false
        }
        else if indexPath == [2,0] {
            itemLabel.text = itemReason
            valueLabel.isHidden = true
        }
        else if indexPath == [3,0] {
            itemLabel.text = editorName
            valueLabel.isHidden = true
        }
        
        return cell
    }

}
