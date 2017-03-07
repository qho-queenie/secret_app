import UIKit

class Step3ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var stopCountDown = false;
    var availableContacts: [String] = [String]()
    
    var contact_id : [Int] = [Int]()
    var contact_status: [Int] = [Int]()
    var contact_phone : [String] = [String]()
    
    @IBOutlet weak var AvailPicker: UIPickerView!
    @IBOutlet weak var selectedContact: UILabel!
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
        
        self.AvailPicker.delegate = self
        self.AvailPicker.dataSource = self
        
        loadData()
        print("Step 3 View Controller")
        
//        if(self.availableContacts.count > 0){
//            TaskGlobalStorage.emergency_contact_name = self.availableContacts[0]
//            self.selectedContact.text = "Selected Contact: \(self.availableContacts[0])"
//            TaskGlobalStorage.emergency_contact_id = contact_id[0]
//            TaskGlobalStorage.emergency_contact_phone = contact_phone[0]
//        }
        
        print(TaskGlobalStorage.user_first_name)
        self.editProfile.setTitle(TaskGlobalStorage.user_first_name, for: .normal)
        print (TaskGlobalStorage.emergency_contact_id)
        print (TaskGlobalStorage.emergency_contact_name)
        print (TaskGlobalStorage.emergency_contact_phone)
        print (TaskGlobalStorage.user_first_name)
        
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(updateTimer), name: .UIApplicationWillEnterForeground, object: nil)

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
    }
    
    func getAvailableContacts(){
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/get_all_available_contacts")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: availCallback)
    }
    
    func availCallback(JSON_response: JSON) {
        print("available contacts:")
        print(JSON_response)
        print(JSON_response[0])
        

        DispatchQueue.main.async {
            self.availableContacts = [String]()
            self.contact_id = [Int]()
            self.contact_status = [Int]()
            self.contact_phone = [String]()
            
            for i in 0..<JSON_response.count
            {
                self.availableContacts.append("\(JSON_response[i]["contact_first_name"].string ?? "") \(JSON_response[i]["contact_last_name"].string ?? "")")
                self.contact_id.append(JSON_response[i]["id"].int ?? 0)
                self.contact_status.append(JSON_response[i]["contact_status"].int ?? 0)
                self.contact_phone.append(JSON_response[i]["contact_phone"].string ?? "")
            }
            print(self.availableContacts)
            self.AvailPicker.reloadAllComponents()
            if(self.availableContacts.count > 0){
                TaskGlobalStorage.emergency_contact_name = self.availableContacts[0]
                self.selectedContact.text = "Selected Contact: \(self.availableContacts[0])"
                TaskGlobalStorage.emergency_contact_id = self.contact_id[0]
                TaskGlobalStorage.emergency_contact_phone = self.contact_phone[0]
            }
            self.checkStartButton()
        }
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
    
    @IBOutlet weak var startButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        getAvailableContacts()
    }
    
    func checkStartButton(){
        var valid = true
        
        if TaskGlobalStorage.minutes == ""{
            print("minutes is not valid")
            valid = false
        }
        if TaskGlobalStorage.emergency_contact_phone == "" {
            print("contact phone is not valid")
            valid = false
        }
        if TaskGlobalStorage.task_name == ""{
            print("task name is not valid")
            valid = false
        }
        if TaskGlobalStorage.emergency_contact_id < 1{
            print("contact id is not valid")
            valid = false
        }
        if TaskGlobalStorage.emergency_contact_name == ""{
            print("contact name is not valid")
            valid = false
        }
        
        if !valid{
            startButton.isHidden = true
        }
        else{
            startButton.isHidden = false
        }
    }

    @IBAction func startAction(_ sender: Any) {
        print("minutes: \(TaskGlobalStorage.minutes)")
        print("task_id: \(TaskGlobalStorage.task_id)")
        print("task_name: \(TaskGlobalStorage.task_name)")
        print("emergency_contact_id: \(TaskGlobalStorage.emergency_contact_id)")
        print("emergency_contact_name: \(TaskGlobalStorage.emergency_contact_name)")
//        print ("additional message is: ")
//        print (additional_message.text!)
        
        var request = URLRequest(url: URL(string: "http://\(TaskGlobalStorage.ip_add)/start_task")!)
        request.httpMethod = "POST"
        let postString = "contact_name=\(TaskGlobalStorage.emergency_contact_name)&contact_phone=\(TaskGlobalStorage.emergency_contact_phone)&user_first_name=\(TaskGlobalStorage.user_first_name)&event_name=\(TaskGlobalStorage.task_name)&minutes=\(TaskGlobalStorage.minutes)&additional_message=\(TaskGlobalStorage.additional_message)"
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
    
    // Picker View funcs:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.availableContacts.count
        print ("fuck")
        print (self.availableContacts.count)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.availableContacts[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TaskGlobalStorage.emergency_contact_name = self.availableContacts[row]
        TaskGlobalStorage.emergency_contact_id = self.contact_id[row]
        TaskGlobalStorage.emergency_contact_phone = self.contact_phone[row]
        self.selectedContact.text = "Selected Contact: \(self.availableContacts[row])"
        checkStartButton()
    }


}
