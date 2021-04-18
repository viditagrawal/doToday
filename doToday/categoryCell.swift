

import UIKit

class categoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBOutlet weak var categoryTasks: UILabel!
    
    @IBOutlet weak var backgroundColorView: DesignableView!
    func setUp(category: Category){
        categoryImage.tintColor = category.color!
        //backgroundColorView.backgroundColor = category.color!
        categoryName.text = category.title!
//        print("WE HAVE: \(category.numberOfTasks!) TASKS")
        categoryTasks.text = "\(category.numberOfTasks!) tasks"
        
        
        contentView.layer.cornerRadius = 6.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -0.8)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    
}
