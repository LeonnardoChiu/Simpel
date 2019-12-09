
import UIKit

class editProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var firstName = String()
    var lastName = String()
    var store = String()
    var role = String()
    var email = String()
    var phone = String()
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        ImagePickerManager().pickImage(self) { image in
            self.image = image
            self.imageView.image = self.image
            self.imageView.contentMode = .scaleAspectFill
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 6
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTableCellID", for: indexPath)
        
        let valueText = cell.contentView.viewWithTag(2) as! UITextField
        
        valueText.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        if indexPath.row == 0 {
            valueText.text = firstName
        }
        else if indexPath.row == 1 {
            valueText.text = lastName
        }
        else if indexPath.row == 2 {
            valueText.text = store
        }
        else if indexPath.row == 3 {
            valueText.text = role
        }
        else if indexPath.row == 4 {
            valueText.text = email
        }
        else {
            valueText.text = phone
        }
        
        return cell
    }
       
    @IBAction func doneClick(_ sender: Any) {
        
        //edit CLOUDKIT
        performSegue(withIdentifier: "goBackToProfile", sender: self)
        
    }
}
