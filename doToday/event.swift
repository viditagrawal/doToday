

import Foundation

public class Event{
    var title: String?
    var description: String?
    var duration: Int?
    var taskType: Int? //This is an index of the task type in the global userCategories
    var isComplete: Bool?
    var intensity: Int?
    var completionTime: String?
    var collab: Bool?
    
    init(title: String, description: String, duration: Int, taskTypeIndex: Int, intensity: Int, collab: Bool){
        self.title          = title
        self.description    = description
        self.duration       = duration
        self.taskType       = taskTypeIndex
        self.isComplete     = false
        self.intensity      = intensity
        self.completionTime = ""
        self.collab         = collab
    }
    
    func addCompletionTime(time: String){
        self.completionTime = time
    }
    
    init(composition: String) {
        let components = composition.components(separatedBy: "√√")
        self.title          = components[0]
        self.description    = components[1]
        self.duration       = Int(components[2])
        self.taskType       = Int(components[3])
        self.isComplete     = Bool(components[4])
        self.intensity      = Int(components[5])
        self.collab         = Bool(components[6])
        
        
    }
    func changeCompletion(){ isComplete! = !isComplete! }
    func changeCollaboration(){ collab! = !collab! }
    
    func decompose() -> String{
        return "\(title!)√√\(description!)√√\(duration!)√√\(taskType!)√√\(isComplete!)√√\(intensity!)√√\(collab!)"
    }
    
    

    
}
