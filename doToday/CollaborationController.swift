
import UIKit
import NaturalLanguage

class CollaborationController: UIViewController {

    @IBOutlet weak var titleView: DesignableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var connectionsTV: UITableView!
    @IBOutlet weak var durationlabel: UILabel!
    var hiddenData = false
    var data_array: [(String, Int)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionsTV.dataSource = self
        connectionsTV.delegate = self
        setUp()
        compareData()
    }
    
    func setUp(){
        titleLabel.text = TodayViewController.selectedEvent.title!
        descriptionLabel.text = TodayViewController.selectedEvent.description!
        durationlabel.text = "\(TodayViewController.selectedEvent.duration!) m."
        let colorName = TodayViewController.userCategories[TodayViewController.selectedEvent.taskType!].color!
        titleView.backgroundColor = colorName
        
        
        if(TodayViewController.selectedEvent.isComplete!){
            defaultLabel.text = "this event is complete :)"
            hiddenData = true
            connectionsLabel.isHidden = true
            connectionsTV.isHidden = true
            self.view.backgroundColor = colorName
        } else {
        
            if(TodayViewController.selectedEvent.collab!){
                defaultLabel.isHidden = true
                connectionsLabel.isHidden = false
                connectionsTV.isHidden = false
            } else {
                defaultLabel.isHidden = false
                connectionsLabel.isHidden = true
                hiddenData = true
                connectionsTV.isHidden = true
                self.view.backgroundColor = colorName
            }
        }
    
    }
    
    func compareData(){
        for key in TodayViewController.otherTasks.keys{
            print(key)
            let current_str = TodayViewController.selectedEvent.title! + " " + TodayViewController.selectedEvent.description!
            for i in 0..<TodayViewController.otherTasks[key]!.1.count{
                let user_str = TodayViewController.otherTasks[key]!.1[i].title! + " " + TodayViewController.otherTasks[key]!.1[i].description!
                let comparison = checkSimilarity(string1: current_str, string2: user_str)
                print("Comparing------------------------")
                print(current_str)
                print(user_str)
                if(comparison){
                    data_array.append((key, i))
                }
            }
        }
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func checkSimilarity(string1: String, string2: String) -> Bool
        {
            let embedding = NLEmbedding.sentenceEmbedding(for: .english)
            var first = false
            let stringArray1 = string1.components(separatedBy: " ")
            let stringArray2 = string2.components(separatedBy: " ")
            var totalSimilarityScore = 0.0
            print(stringArray1)
            print(stringArray2)
            let distance = embedding!.distance(between: string1.lowercased(), and: string2.lowercased())
            print(distance.description)
            if distance < 1{
                return true
            }
            else{
                return false
            }
            
            
        }

}


extension CollaborationController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(data_array.count == 0 && !hiddenData){
            defaultLabel.text = "unfortunately there was no match, please try again later!"
            defaultLabel.isHidden = false
            connectionsTV.isHidden = true
        } else if(data_array.count != 0 && !hiddenData){
            defaultLabel.isHidden = true
            connectionsTV.isHidden = false
        }
        return data_array.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connection") as! connectionCell
        let tuple_data = data_array[indexPath.row]
        let user_initial = TodayViewController.otherTasks[tuple_data.0]!.0.name!.prefix(1)
        let user_name = TodayViewController.otherTasks[tuple_data.0]!.0.name!
        let task_title = TodayViewController.otherTasks[tuple_data.0]!.1[tuple_data.1].title!
        let email = TodayViewController.otherTasks[tuple_data.0]!.0.contact!

        cell.set(initial: String(user_initial), title: task_title, name: user_name, email: email)
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
