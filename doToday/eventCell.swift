

import UIKit

class eventCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleHolderView: DesignableView!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var emptyTVLabel: UILabel!
    @IBOutlet var testTimeLabel: UILabel!
    
    static var date:Date? = Date()
    

    func set(event: Event){
        
        emptyTVLabel.isHidden = true
        titleHolderView.isHidden = false
        timingLabel.isHidden = false
        titleLabel.text = event.title!
//        testTimeLabel.text = "\(event.duration!) Seconds"
        if self.titleLabel.text == TodayViewController.userTasks[0].title! {
            eventCell.date = Date()

        }
//        let calendar = Calendar.current
//        eventCell.date = calendar.date(byAdding: .minute, value: event.duration!, to: eventCell.date!)
//        let formatter = DateFormatter()
//        formatter.timeStyle = .short
//        print(formatter.string(from: eventCell.date!))
        self.timingLabel.text = event.completionTime
        
        if(event.isComplete!){
            titleHolderView.backgroundColor = .lightGray
        }else {
            titleHolderView.backgroundColor = TodayViewController.userCategories[event.taskType!].color!
        }
    }
    
    func setEmpty(){
        emptyTVLabel.isHidden = false
        titleHolderView.isHidden = true
        timingLabel.isHidden = true
    }
    
}
