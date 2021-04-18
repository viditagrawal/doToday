
import Foundation
import UIKit

protocol changed{
    func changed_sorting_method()
}


class YouViewController: UIViewController {
    
    @IBOutlet weak var statsLabel: UILabel!
    var delegate: changed!

    var settingStrings = ["Hapic Feedback", "Color Theme", "Organization", "Stuff"]
    override func viewDidLoad() {
        var activities = 0
        var hours_c = 0
        var hours_l = 0
        var final_time = ""
        for event in TodayViewController.userTasks{
            activities += 1
            if(event.isComplete!){
                hours_c+=event.duration!
            } else {
                hours_l+=event.duration!
            }
            final_time = event.completionTime!
        }
        let stringValue = "You have \(activities) activities. You have completed \(hours_c) hours and have \(hours_l) left. You should be done by \(final_time). You're almost done!!"

        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "You have", withColor: UIColor.systemGray)
        attributedString.setColorForText(textForAttribute: "activities. ", withColor: UIColor.systemGray)
        attributedString.setColorForText(textForAttribute: "You have completed ", withColor: UIColor.systemGray)
        attributedString.setColorForText(textForAttribute: "hours and have ", withColor: UIColor.systemGray)
        attributedString.setColorForText(textForAttribute: "left.", withColor: UIColor.systemGray)
        attributedString.setColorForText(textForAttribute: "You should be done by", withColor: UIColor.systemGray)
        attributedString.setColorForText(textForAttribute: ". You're almost done!!", withColor: UIColor.systemGray)

        statsLabel.attributedText = attributedString
    }
   
    @IBAction func change_sorting(_ sender: DesignableButton) {
        TodayViewController.sorting = sender.tag
        delegate.changed_sorting_method()
    }
    @IBAction func go_back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

