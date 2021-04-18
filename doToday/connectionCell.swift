
import UIKit

class connectionCell: UITableViewCell {
    
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!


    func set(initial: String, title: String, name: String, email: String){
        self.initialLabel.text = initial
        self.initialLabel.layer.cornerRadius = 25
        self.initialLabel.clipsToBounds = true
        self.titleLabel.text = title
        self.name.text = name
        self.email.text = email
    }

}
