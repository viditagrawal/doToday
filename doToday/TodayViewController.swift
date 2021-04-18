

import UIKit
import Foundation
import FirebaseDatabase


class TodayViewController: UIViewController{
    @IBOutlet var day: UILabel!
    @IBOutlet var quote: UILabel!
    @IBOutlet weak var tasksTV: UITableView!
    @IBOutlet weak var categoriesCV: UICollectionView!
    
    
    public static var userTasks: [Event] = [Event]()
    static var userCategories: [Category] = [Category]()
    static var otherTasks: [String: (Person, [Event])] = [String: (Person, [Event])]()
    static var selectedEvent: Event!
    static var sorting = 2
    var read_other_data = false
    let UID = "B9A60ECC-E579-46BE-9A9A-66287D45AC6C"
    let storedData = UserDefaults.standard
    let startingDate = Date()
    var myPerson: Person!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTV.delegate = self
        tasksTV.dataSource = self
        categoriesCV.dataSource = self
        categoriesCV.delegate = self
        
        let layout = UICollectionViewFlowLayout()
    

        let itemSpacing: CGFloat = 10
        let itemsInOneLine: CGFloat = 2
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        layout.itemSize = CGSize(width: categoriesCV.frame.width/2-30, height: categoriesCV.frame.height/2-10)
        layout.scrollDirection = .horizontal
        categoriesCV.isScrollEnabled = true
        categoriesCV.collectionViewLayout = layout
        
        readInSortData()
        readInDateData()
        readInCategoryData()
        readInTaskData{ (success) in
            if(success){
                self.tasksTV.reloadData()
                self.categoriesCV.reloadData()
                self.startTime()
            }
        }
        

        TodayViewController.userCategories = [Category.init(title: "Work", color: "PastelRed"), Category.init(title: "Other", color: "PastelGreen"), Category.init(title: "Personal", color: "PastelPurple"), Category.init(title: "Play", color: "PastelLilac")]
        //TodayViewController.userTasks = [Event.init(title: "Meeting With Ritvik Banakar", description: "We are going to meet to discuss future projects", duration: 30, taskTypeIndex: 0), Event.init(title: "Go to Gym", description: "We are going to meet to discuss future projects", duration: 120, taskTypeIndex: 1)]
        // Do any additional setup after loading the view.
    }
    
    
    
    func startTime(){
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [self] _ in
            self.tasksTV.reloadData()
            for task in TodayViewController.userTasks{
                TodayViewController.userCategories[task.taskType!].reset()
            }
            for task in TodayViewController.userTasks{
                TodayViewController.userCategories[task.taskType!].addTask()
            }
            self.sortTasks()
            self.tasksTV.reloadData()
            self.categoriesCV.reloadData()
        }
    }
    func readInDateData(){
        let dayQuote = storedData.string(forKey: "Day")
        
        if let dayQuoteValue = dayQuote{
            
            let date = Date()
            let calendar = Calendar.current
            // Day generator, calender.component returns int from 1-7 indicating day of week.
            let dayNumber = calendar.component(.weekday, from: date)
            
            let components = dayQuoteValue.components(separatedBy: "-")
        
            if(Int(components[0]) == dayNumber){
                calculateDayandQuote(storedDateNumber: Int(components[0])!, storedQuoteNumber: 10)
            } else {
                calculateDayandQuote(storedDateNumber: -1, storedQuoteNumber: -1)
            }

        } else{
            calculateDayandQuote(storedDateNumber: -1, storedQuoteNumber: -1)
        }
        
    }
    
    func readInSortData(){
        let sort = storedData.string(forKey: "Sorting")
//        print(sort)
        if let sortingMethod = sort{
            print("IN HERE")
            TodayViewController.sorting = Int(sortingMethod)!
        }
        
    }
    func readInCategoryData(){
        let categoryData = storedData.array(forKey: "CategoryData") as? [String] ?? [String]()
        for categoryString in categoryData{
            TodayViewController.userCategories.append(Category(composition: categoryString))
        }
        
    }
    func readInTaskData(success:@escaping (Bool) -> Void){
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let data = snapshot.value as? [String: Any]{
//                print(data)
                //GETTING OTHERS DATA
                for dict in data{
                    if(dict.key != self.UID){
                        var event_array = [Event]()
                        var userID = dict.key
                        
                        let dictionary = dict.value as! NSDictionary
                        
                        let contact: String = dictionary["contact"]! as! String
                        let name:String = dictionary["name"]! as! String
                        let person = Person(n: name, c: contact)
                        
                        let task_values = dictionary["tasks"] as! [String]
                        for taskString in task_values{
                            let newEvent = Event(composition: taskString)
                            event_array.append(newEvent)
                        }
                        TodayViewController.otherTasks[userID] = (person, event_array)
                        
                    }
                }
                //GETTING MY OWN DATA
                if(!self.read_other_data){
                    let my_data: [String: Any] = data[self.UID] as! [String: Any]
                   
                    let contact: String = my_data["contact"]! as! String
                    let name:String = my_data["name"]! as! String
                    self.myPerson = Person(n: name, c: contact)
                    let values = my_data["tasks"] as! [String]
                    for taskString in values{
    //                    print(taskString)
                        let newEvent = Event(composition: taskString)
                        TodayViewController.userTasks.append(newEvent)
                        TodayViewController.userCategories[newEvent.taskType!].addTask()
                        TodayViewController.userCategories[newEvent.taskType!].addHours(event: newEvent)
                    }
                    print("Sorted Tasks")
                    self.sortTasks()
                }
//                self.tasksTV.reloadData()
            }
            success(true)
        }) { (error) in
            print(error.localizedDescription)
            success(false)
        }
            
    }
    //
//    func readInTaskData(){
//         let num = storedData.string(forKey: "NumberOfTasks")
//
//        if let number = num{
//            let numerical = Int(number)
//
//
//        }
//    }
        
    func calculateDayandQuote(storedDateNumber: Int, storedQuoteNumber: Int){
        
        let date = Date()
        let calendar = Calendar.current
        // Day generator, calender.component returns int from 1-7 indicating day of week.
        var dayNumber = calendar.component(.weekday, from: date)
        if(storedDateNumber != -1) { dayNumber = storedDateNumber }
        
        switch dayNumber{
        case 1: day.text = "sunday."
        case 2: day.text = "monday."
        case 3: day.text = "tuesday."
        case 4: day.text = "wednesday."
        case 5: day.text = "thursday."
        case 6: day.text = "friday."
        case 7: day.text = "saturday."
        default: day.text = "today."
        }
        

        var randomNumber = Int.random(in: 0 ..< quotes.messages.count)
        if(storedQuoteNumber != -1){ randomNumber = storedQuoteNumber }
        let randomQ = quotes.messages[randomNumber]
        let randomA = quotes.authors[randomNumber]
        quote.numberOfLines = 6
        quote.text = "\(randomQ)"
        if(storedDateNumber == -1){ storedData.set("\(dayNumber)-\(randomNumber)", forKey: "Day") }
    }

    @IBAction func sequeToYou(_ sender: Any) {
        saveToFirebase()
        let newvc = self.storyboard?.instantiateViewController(withIdentifier: "You") as! YouViewController
        newvc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        newvc.delegate = self
        self.present(newvc, animated: true, completion: nil)
    }
    @IBAction func segueToTaskCreation(_ sender: Any) {
        let newvc = self.storyboard?.instantiateViewController(withIdentifier: "NewTaskVC") as! NewTaskViewController
        newvc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        newvc.delegate = self
        self.present(newvc, animated: true, completion: nil)
    }
    
    
    @IBAction func startButton(_ sender: Any) {
        let newvc = self.storyboard?.instantiateViewController(withIdentifier: "TimerVC") as! TimerVC
        newvc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(newvc, animated: true, completion: nil)
    }
    
    
}


extension TodayViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksTV.isScrollEnabled = false
        if(TodayViewController.userTasks.count == 0){ return 1 }
        tasksTV.isScrollEnabled = true
//        print(TodayViewController.userTasks.count)
        return TodayViewController.userTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! eventCell

        if(TodayViewController.userTasks.count > 0){
            let task = TodayViewController.userTasks[indexPath.row]
            cell.set(event: task)
        } else{ cell.setEmpty() }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print(index)
        saveToFirebase()
        TodayViewController.selectedEvent = TodayViewController.userTasks[indexPath.row]
        read_other_data = true
        readInTaskData{ (success) in
            if(success){
            let newvc = self.storyboard?.instantiateViewController(withIdentifier: "collab") as! CollaborationController
            newvc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
    //        newvc.delegate = self
            self.present(newvc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        // 1
        let collab = TodayViewController.userTasks[indexPath.row].collab!
        var titleString = "No Collab"
        if(!collab){
            titleString = "Yes Collab"
        }
        let shareAction = UITableViewRowAction(style: .default, title: titleString , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
        // 2
            TodayViewController.userTasks[indexPath.row].changeCollaboration()
            
        })
    
        shareAction.backgroundColor = .gray
//        shareAction.backgroundColor = .gray

        return [shareAction]
    }
    
    
    
    
}


extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TodayViewController.userCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! categoryCell
        cell.setUp(category: TodayViewController.userCategories[indexPath.row])
        cell.layoutIfNeeded()

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width  = collectionView.frame.width
        return CGSize(width: width, height: height)
    }
}

extension TodayViewController: newTaskDelegate, changed{
   
    func createTask(title: String, description: String, duration: Int, categoryIndex: Int, intensity: Int) {
        let newEvent = Event(title: title, description: description, duration: duration, taskTypeIndex: categoryIndex, intensity: intensity, collab: true)
        TodayViewController.userTasks.append(newEvent)
        TodayViewController.userCategories[categoryIndex].addTask()
        TodayViewController.userCategories[categoryIndex].addHours(event: newEvent)
        sortTasks()
//        TodayViewController.userTasks = TodayViewController.userTasks.sorted(by: { $0.intensity! > $1.intensity! })
        tasksTV.reloadData()
        categoriesCV.reloadData()
        
        saveData()
        
    }
    
    func sortTasks(){
        if(TodayViewController.sorting == 1){
            TodayViewController.userTasks = TodayViewController.userTasks.sorted(by: { $0.intensity! < $1.intensity! })
            
        }
        else if(TodayViewController.sorting == 2){
            TodayViewController.userTasks = TodayViewController.userTasks.sorted(by: { $0.intensity! > $1.intensity! })
            
        }
        else{
            var temp_array = TodayViewController.userTasks.sorted(by: { $0.intensity! > $1.intensity! })
            let split_array = temp_array.split()
            var final_array: [Event] = []
            temp_array = split_array[0]
            let temp_array2 = split_array[1]
            let count = temp_array2.count-1
            for i in 0..<temp_array2.count{
                final_array.append(temp_array[i])
                final_array.append(temp_array2[count - i])
            }
            if(temp_array2.count != temp_array.count){
                final_array.append(temp_array[temp_array.count-1])
            }
            TodayViewController.userTasks = final_array
        }
        var totalTime = 0
        for i in 0..<TodayViewController.userTasks.count{
            totalTime += TodayViewController.userTasks[i].duration!
            let time = startingDate.adding(minutes: totalTime)
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            TodayViewController.userTasks[i].addCompletionTime(time: formatter.string(from: time))
            
        }
        
    }
    
    func changed_sorting_method() {
        sortTasks()
        saveData()
        tasksTV.reloadData()
        categoriesCV.reloadData()
    }
    
    
    func saveData(){
        print("saved")
        var decomposedCategories: [String] = [String]()
        var decomposedTasks: [String] = [String]()
        for category in TodayViewController.userCategories{
           decomposedCategories.append(category.decompose())
        }
        for task in TodayViewController.userTasks{
           decomposedTasks.append(task.decompose())
        }
       
        storedData.set(TodayViewController.sorting, forKey: "Sorting")
        storedData.set(decomposedCategories, forKey: "CategoryData")
        storedData.set(decomposedTasks, forKey: "TaskData")
        saveToFirebase()
    }
    
    func saveToFirebase(){
        var ref: DatabaseReference! = Database.database().reference()
        var dataDictionary: [String: Any] = [:]
        var decomposedTasks: [String] = [String]()
        for task in TodayViewController.userTasks{
           decomposedTasks.append(task.decompose())
        }
        dataDictionary["tasks"] = decomposedTasks
        dataDictionary["name"] = myPerson.name
        dataDictionary["contact"] = myPerson.contact
        ref.child(UID).setValue(dataDictionary)
    }
    
    
}

