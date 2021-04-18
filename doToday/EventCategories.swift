

import Foundation
import UIKit

public class Category{
    var title: String?
    var color: UIColor?
    var colorName: String?
    var numberOfTasks: Int?
    var numberOfHours: Int?
    
    init(title: String, color: String){
        self.title = title
        self.color = UIColor(named: color)
        self.colorName = color
        self.numberOfTasks = 0
        self.numberOfHours = 0
    }
    
    func addTask(){ numberOfTasks! += 1 }
    func removeTask(){ numberOfTasks! -= 1 }
    func reset(){numberOfTasks! = 0}
    
    func addHours(event: Event){ numberOfHours! += event.duration! }
    func removeHours(event: Event){ numberOfHours! -= event.duration! }
    
    init(composition: String){
//        print("were in here")
        let components = composition.components(separatedBy: "√√")
        self.title          = components[0]
        self.colorName      = components[1]
        self.color          = UIColor(named: self.colorName!)
        self.numberOfTasks = 0
        self.numberOfHours = 0
    }
    
    func decompose() -> String{
        return "\(title!)√√\(colorName!)"
    }
    
    
}
