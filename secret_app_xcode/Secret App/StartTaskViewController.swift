import UIKit

class Step3ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Step 3 View Controller")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startAction(_ sender: Any) {
        print("minutes: \(TaskGlobalStorage.minutes)")
        print("task_id: \(TaskGlobalStorage.task_id)")
        print("task_name: \(TaskGlobalStorage.task_name)")
        print("emergency_contact_id: \(TaskGlobalStorage.emergency_contact_id)")
        print("emergency_contact_name: \(TaskGlobalStorage.emergency_contact_name)")
        
        var request = URLRequest(url: URL(string: "http://localhost:5000/start_task")!)
        request.httpMethod = "POST"
        let postString = "contact_name=\(TaskGlobalStorage.emergency_contact_name)&contact_phone=\(TaskGlobalStorage.emergency_contact_phone)&user_first_name=\(TaskGlobalStorage.user_first_name)&event_name=\(TaskGlobalStorage.task_name)&minutes=\(TaskGlobalStorage.minutes)"
        request.httpBody = postString.data(using: .utf8)
        HTTP.request(request: request, callback: timerReqCallback)
        
    }
    @IBOutlet weak var timerLabel: UILabel!
    
    func timerReqCallback(data: JSON){
        print(Int(TaskGlobalStorage.minutes)!*60)
        timerCount(totalSeconds: Int(TaskGlobalStorage.minutes)!*60 )
    }
    
    func timerCount(totalSeconds: Int){
        var timeMinutes = totalSeconds / 60
        var timeSeconds = totalSeconds % 60
        var total = totalSeconds
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            timeSeconds = timeSeconds - 1
            var timeMinuteString = ""
            var timeSecondString = ""
            if(timeSeconds < 0){
                timeMinutes = timeMinutes - 1
                timeSeconds = 59
            }
            if(timeMinutes < 10){
                timeMinuteString = "0"
            }
            timeMinuteString += String(timeMinutes)
            
            if(timeSeconds < 10){
                timeSecondString = "0"
            }
            timeSecondString += String(timeSeconds)
            
            print(timeMinuteString + ":" + timeSecondString)
            self.timerLabel.text! = timeMinuteString + ":" + timeSecondString
            
            if(totalSeconds > 1){
                total = total - 1
                self.timerCount(totalSeconds: total)
            }
        }
    }

}
