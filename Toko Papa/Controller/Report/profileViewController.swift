
import UIKit

class profileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    var peoples: [People] = []
    // Delegate
    weak var delegate: EmployeeListViewController?
    
    // init model
    
    var firstNameTemp = String()
    var lastNameTemp = String()
    var storeTemp = String()
    var roleTemp = String()
    var emailTemp = String()
    var phoneTemp = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        //nameLabel.text = "\(Budi.firstName) \(Budi.lastName)"
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 35
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame

        let title = UILabel()
        
        title.frame =  CGRect(x: 10, y: 13, width: headerFrame.size.width-20, height: 20) //width equals to parent view with 10 left and right margin
        title.text = self.tableView(tableView, titleForHeaderInSection: section) //This will take title of section from 'titleForHeaderInSection' method or you can write directly
        title.font = UIFont.systemFont(ofSize: 14)
        title.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: headerFrame.size.width, height: headerFrame.size.height))
        headerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headerView.addSubview(title)

        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        else {
            return "SETTINGS"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableID", for: indexPath)
        
        let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let valueLabel = cell.contentView.viewWithTag(2) as! UILabel
        valueLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        if indexPath.section == 1 {
            valueLabel.isHidden = true
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }
        
        if indexPath == [0,0]{
            nameLabel.text = "Store Name"
            //valueLabel.text = Budi.store
        }
        else if indexPath == [0,1]{
            nameLabel.text = "Role"
            //valueLabel.text = Budi.role
        }
        else if indexPath == [0,2]{
            nameLabel.text = "Email"
            //valueLabel.text = Budi.email
        }
        else if indexPath == [0,3]{
            nameLabel.text = "Phone Number"
            //valueLabel.text = Budi.phone
        }
        
        if indexPath == [1,0] {
            //nameLabel.text = "Security"
        }
        else if indexPath == [1,1] {
            //nameLabel.text = "About Us"
        }
        else if indexPath == [1,2] {
            //nameLabel.text = "Sign Out"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            let destinationVC = segue.destination as? editProfileViewController
            
//            destinationVC!.firstName = Budi.firstName
//            destinationVC!.lastName = Budi.lastName
//            destinationVC!.store = Budi.store
//            destinationVC!.role =  Budi.role
//            destinationVC!.email = Budi.email
//            destinationVC!.phone = Budi.phone
            
        }
    }
    
    @IBAction func unwindToProfileVC(segue: UIStoryboardSegue) {
        print("updated")
    }
    

}
