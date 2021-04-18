
import UIKit

protocol newTaskDelegate{
    func createTask(title: String, description: String, duration: Int, categoryIndex: Int, intensity: Int)
}

class NewTaskViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var addTaskTf: UITextField!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var descriptionPlaceholder: UILabel!
    @IBOutlet weak var intensityLevel: UISegmentedControl!
    @IBOutlet weak var durationTf: UITextField!
    @IBOutlet weak var done_button: DesignableButton!
    var totalTVString = "" //For the description Text View
    var totalString = "" //For the add task text field
    var delegate: newTaskDelegate!
    var selected_index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        print("in here")
        descriptionTv.delegate = self
        addTaskTf.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 25

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 150 characters
        if(updatedText.count == 0){ descriptionPlaceholder.isHidden = false} else { descriptionPlaceholder.isHidden = true}
        return updatedText.count <= 150
    }
    
    @IBAction func changed_category(_ sender: DesignableButton) {
        selected_index = sender.tag
        switch selected_index {
        case 0:
            done_button.backgroundColor = UIColor(named: "PastelRed")
        case 1:
            done_button.backgroundColor = UIColor(named: "PastelGreen")
        case 2:
            done_button.backgroundColor = UIColor(named: "PastelPurple")
        case 3:
            done_button.backgroundColor = UIColor(named: "PastelLilac")
        default:
            done_button.backgroundColor = .gray
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    @IBAction func addNewTask(_ sender: Any) {
        print(addTaskTf.text)
        print(descriptionTv.text)
        print(durationTf.text)
        delegate.createTask(title: addTaskTf.text!, description: descriptionTv.text!, duration: Int(durationTf.text!)!, categoryIndex: selected_index, intensity: intensityLevel.selectedSegmentIndex+1)
        self.dismiss(animated: true, completion: nil)
    
    }
    
}
