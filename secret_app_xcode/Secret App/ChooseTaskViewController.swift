import UIKit

public class TaskGlobalStorage{
    public static var minutes:String = ""
    public static var task_id:Int = 0
    public static var task_name:String = ""
    public static var emergency_contact_id:Int = 0
    public static var emergency_contact_name:String = ""
    public static var emergency_contact_phone:String = ""
    public static var user_first_name:String = ""
    public static var user_last_name:String = ""
    public static var user_email:String = ""
    public static var user_number:String = ""
    public static var user_id:Int = -1
    
    public static var ip_add = "54.193.124.182"
    
}

class Step1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var editProfile: UIButton!
    
    @IBOutlet weak var valid: UILabel!
    @IBOutlet weak var add_event: UIButton!
    @IBOutlet weak var remove_task: UIButton!
    var picker: [String] = [String]()
    var public_event_id : [Int] = [Int]()
    @IBOutlet weak var eventPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Step 1 View Controller")
        self.eventPicker.delegate = self
        self.eventPicker.dataSource = self
    }

    func loadData(){
        var url = URL(string: "http://\(TaskGlobalStorage.ip_add)/display_events")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: loadDataCallback)
        
        
        url = URL(string: "http://\(TaskGlobalStorage.ip_add)/display_user")
        request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: getUserCallback)
        print ("url")
        print (url)
    }
    
    func getUserCallback(JSON_response: JSON){
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
            }
        }
    }



    
    func loadDataCallback(JSON_response: JSON){
        self.picker = []
        self.public_event_id = []
        
        print("loadDataCallback")
        print(JSON_response)
        
        if let unwrapped = JSON_response["data"][0]["first_name"].string {
            TaskGlobalStorage.user_first_name = unwrapped
        }
        
        if let unwrapped = JSON_response["data"][0]["last_name"].string {
            TaskGlobalStorage.user_last_name = unwrapped
        }
        if let unwrapped = JSON_response["data"][0]["email"].string {
            TaskGlobalStorage.user_email = unwrapped
        }
        if let unwrapped = JSON_response["data"][0]["phone"].string {
            TaskGlobalStorage.user_number = unwrapped
        }
        
        for index in 0..<JSON_response["data"].count{
            var toAppend = JSON_response["data"][index]["event_name"]
            var toAppendEventId = JSON_response["data"][index]["id"]
            print("event:\(toAppend) id:\(toAppendEventId)")
            self.picker.append(toAppend.string!)
            self.public_event_id.append(toAppendEventId.int!)
        }
        
        if JSON_response["data"].count > 0{
            TaskGlobalStorage.task_name = picker[0]
            TaskGlobalStorage.task_id = public_event_id[0]
        }
        
        print("picker arr:")
        print(self.picker)
        
        DispatchQueue.main.async {
            self.eventPicker.reloadAllComponents()
            self.editProfile.setTitle(TaskGlobalStorage.user_first_name, for: .normal)
        }
    }

    @IBAction func remove_task_action(_ sender: UIButton) {
        print ("fuck")
        print (eventPicker.selectedRow(inComponent: 0))
        
        
        
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/delete_event?id=\(public_event_id[eventPicker.selectedRow(inComponent: 0)])")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: removeCallback)
    }
    
    func removeCallback(data: JSON){
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        loadData()
    }
    
    @IBAction func add_event_func(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add New Event", message: "Enter an event", preferredStyle: .alert)
        
        alert.addTextField { (textField_event_name) in
            textField_event_name.placeholder = "Enter new event name here"
        }
        
        alert.addTextField { (textField_event_note) in
            textField_event_note.placeholder = "Enter event's note here(optional)"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            var textField_event_name = ""
            var textField_event_note = ""
            
            if let value = alert?.textFields![0].text{
                textField_event_name = value
            }
            
            if let value = alert?.textFields![1].text{
                textField_event_note = value
            }
            
            let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/add_new_event")
            
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            let postString = "event_name=\(textField_event_name)&event_note=\(textField_event_note)"
                    print (postString)
            request.httpBody = postString.data(using: .utf8)
            
            HTTP.request(request: request, callback: self.post_new_event)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func post_new_event(data : JSON){
        print (data)
        DispatchQueue.main.async {
            print ("bitch ass")
            print (data["success"])
            if (data["success"] == true){
                print ("nth")
                self.valid.text = " "
            }
            else {
                    self.valid.text! = (data["validation_errors"].string)!
                }
        }
        loadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Text Field funcs:
    
    func textFieldDidChange(_ textField: UITextField) {
//        print(textField.text!)
        TaskGlobalStorage.minutes = textField.text!
        print (TaskGlobalStorage.minutes)
    }

    
    
    // Picker View funcs:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TaskGlobalStorage.task_name = picker[row]
        TaskGlobalStorage.task_id = public_event_id[row]
        print (TaskGlobalStorage.task_name)
        print(TaskGlobalStorage.task_id)
    }
    
}
