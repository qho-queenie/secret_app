import UIKit

class Step3ViewController: UIViewController {
    var stopCountDown = false;
    @IBOutlet weak var additional_message: UITextField!
    @IBOutlet weak var stopButton: UIButton!
    @IBAction func stopCount(_ sender: Any) {
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/end_current_task")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: endCountDownCallback)
    }
    
    func endCountDownCallback(data:JSON){
        self.stopCountDown = true;
    }
    @IBOutlet weak var editProfile: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print("Step 3 View Controller")
        self.editProfile.setTitle(TaskGlobalStorage.user_first_name, for: .normal)
        print (TaskGlobalStorage.emergency_contact_id)
        print (TaskGlobalStorage.emergency_contact_name)
        print (TaskGlobalStorage.emergency_contact_phone)
        print (TaskGlobalStorage.user_first_name)
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimerCallbackWithoutStart), name: .UIApplicationWillEnterForeground, object: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/display_user")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: loadDataCallback)
        print ("url")
        print (url)
    }
    
    func loadDataCallback(JSON_response: JSON){
        if let unwrapped = JSON_response["data"][0]["id"].int {
            TaskGlobalStorage.user_id = unwrapped
        }
        else{
            TaskGlobalStorage.user_id = 0
        }
        
        print("loadDataCallback")
        print(JSON_response)
        print(JSON_response["data"].count)
        
        
        DispatchQueue.main.async {
            if (TaskGlobalStorage.user_id == 0){
                self.navigationController?.popViewController(animated: true)
            }else{
                self.updateTimer(start: true)
            }
        }
    }

    @IBAction func startAction(_ sender: Any) {
        print("minutes: \(TaskGlobalStorage.minutes)")
        print("task_id: \(TaskGlobalStorage.task_id)")
        print("task_name: \(TaskGlobalStorage.task_name)")
        print("emergency_contact_id: \(TaskGlobalStorage.emergency_contact_id)")
        print("emergency_contact_name: \(TaskGlobalStorage.emergency_contact_name)")
        print ("additional message is: ")
        print (additional_message.text!)
        
        
        var request = URLRequest(url: URL(string: "http://\(TaskGlobalStorage.ip_add)/start_task")!)
        request.httpMethod = "POST"
        let postString = "contact_name=\(TaskGlobalStorage.emergency_contact_name)&contact_phone=\(TaskGlobalStorage.emergency_contact_phone)&user_first_name=\(TaskGlobalStorage.user_first_name)&event_name=\(TaskGlobalStorage.task_name)&minutes=\(TaskGlobalStorage.minutes)&additional_message=\(additional_message.text!)"
        print (postString)
        request.httpBody = postString.data(using: .utf8)
        HTTP.request(request: request, callback: timerReqCallback)
        
        self.stopButton.isHidden = false;
        
    }
    @IBOutlet weak var timerLabel: UILabel!
    
    func timerReqCallback(data: JSON){
        print(Int(TaskGlobalStorage.minutes)!*60)
        timerCount(totalSeconds: Int(TaskGlobalStorage.minutes)!*60 )
        self.stopCountDown = false;
    }
    
    var total = 0;
    var timerRunning = false;
    
    func timerCount(totalSeconds: Int){
        self.timerRunning = true;
        var timeMinutes = totalSeconds / 60
        var timeSeconds = totalSeconds % 60
        self.total = totalSeconds
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            timeSeconds = timeSeconds - 1
            var timeMinuteString = ""
            var timeSecondString = ""
            if(timeSeconds < 0){
                timeMinutes = timeMinutes - 1
                timeSeconds = 59
                self.updateTimer(start: false)
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
            
            if(totalSeconds > 1 && self.stopCountDown == false){
                self.total = self.total - 1
                self.timerCount(totalSeconds: self.total)
            }
            else
            {
                self.timerRunning = false;
            }
        }
    }
    
    func updateTimer(start: Bool){
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/get_current_timer")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        if(start){
            HTTP.request(request: request, callback: updateTimerCallbackWithStart)
        }
        else{
            HTTP.request(request: request, callback: updateTimerCallbackWithoutStart)
        }
    }
    
    func updateTimerCallbackWithoutStart(data: JSON){
        print(data)
        if let timeRemaining = data["timeRemaining"].int{
            self.total = timeRemaining
        }
    }
    
    func updateTimerCallbackWithStart(data: JSON){
        updateTimerCallbackWithoutStart(data: data)
        if(self.total > 0 && !self.timerRunning){
            timerCount(totalSeconds: self.total)
        }
    }

}
