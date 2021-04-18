

import UIKit

class TimerVC: UIViewController {

    @IBOutlet weak var timerView: UIView!
    var totalTime = 10.0
    var timer: Timer?
    var time = 0.0
    var index = 0
    @IBOutlet weak var doneButton: DesignableButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    var timerDone: Bool = false
    var isPaused: Bool = true
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        doneButton.isHidden = true
        //timerView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        for i in 0..<TodayViewController.userTasks.count{
            if(!TodayViewController.userTasks[i].isComplete!){
                totalTime = Double(TodayViewController.userTasks[i].duration! * 1)
                titleLabel.text = TodayViewController.userTasks[i].title!
                index = i
                break
            }
        }
        
        switch TodayViewController.userTasks[index].taskType! {
        case 0:
            timerView.backgroundColor = UIColor(named: "PastelRed")
        case 1:
            timerView.backgroundColor = UIColor(named: "PastelGreen")
        case 2:
            timerView.backgroundColor = UIColor(named: "PastelPurple")
        case 3:
            timerView.backgroundColor = UIColor(named: "PastelLilac")
        default:
            timerView.backgroundColor = .gray
        }
        
        
//        timeLabel.frame = CGRect(x: self.view.frame.width/2 - 55, y: self.view.frame.height/2 - 85, width: timeLabel.frame.width, height: timeLabel.frame.height+100)
        timeLabel.text = ""
        timeLabel.font = UIFont.systemFont(ofSize: 30)
        titleLabel.font = UIFont.systemFont(ofSize: 45, weight: .semibold)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        self.timerView.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        UIView.animate(withDuration: 0.75, delay: 0.1, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                     self.promptLabel.transform = CGAffineTransform(translationX: 0, y: -10)
         //            CGAffineTransform(translationX: 0, y: -15)
        }, completion: nil)
    }
    
    
    
    func start(){
        UIView.animate(withDuration: 2, delay: 0.1, options: [.curveEaseInOut], animations: {
            self.promptLabel.alpha = 0
//            CGAffineTransform(translationX: 0, y: -15)
        }, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer?) {
        print("here")
        doneButton.isHidden = false
        if(isPaused)
        {
            timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
            self.promptLabel.transform = .identity
            UIView.animate(withDuration: 1, animations: {
                self.promptLabel.alpha = 0.0
            })
            isPaused = false
        }
        else
        {
            timer?.invalidate()
            isPaused = true
        }

    }
    
    
    @objc func runTimedCode(){
        time = time + 0.02
        var factor = CGFloat(1-CGFloat(self.time)/CGFloat(self.totalTime))
      
        if(abs(floor(time) - time) < 0.04)
        {
            
            timeLabel.text = "\(Int(floor(totalTime - time)))"

        }
       
        if(abs(time - self.totalTime) < 0.001)
        {

            timer!.invalidate()
            factor = 1
            timerView.backgroundColor = UIColor(red: 0, green: 1.0, blue: 0, alpha: 0.3)
            self.timeLabel.text = "\(0)"
            
            UIView.animate(withDuration: 2, animations: {
                var transforms = CGAffineTransform.identity
//                transforms = transforms.scaledBy(x: 1, y: factor)
                self.timerView.transform = transforms
                

            })
            timerDone = true
            TodayViewController.userTasks[index].changeCompletion()
        }
        else
        {

        UIView.animate(withDuration: 1, animations: {
            var transforms = CGAffineTransform.identity
            transforms = transforms.scaledBy(x: 1, y: factor)
            self.timerView.transform = transforms


        })
        }
        

    }
    
  
    
    @IBAction func doneButton(_ sender: Any) {
        if(timerDone == false)
        {
            timerView.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
            UIView.animate(withDuration: 3, animations: {
                var transforms = CGAffineTransform.identity
                transforms = transforms.scaledBy(x: 1, y: 1)
                self.timerView.transform = transforms
                
                self.incrementLabel(to: Int(self.totalTime))
            }, completion: { (finished: Bool) in
                self.dismiss(animated: true, completion: nil)
            })
        }
        else
        {
            self.dismiss(animated: true, completion: nil)
        }
        timer!.invalidate()
        
        
    }
    func incrementLabel(to endValue: Int) {
        let duration: Double = 3 //seconds
        DispatchQueue.global().async { [self] in
            let initial = Int(timeLabel.text!)
            for i in initial! ..< (endValue + 1) {
                let sleepTime = UInt32(duration/Double(endValue) * 1000000.0)
                usleep(sleepTime)
                DispatchQueue.main.async {
                    self.timeLabel.text = "\(i-1)"
                    
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
