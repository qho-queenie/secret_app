import UIKit

class Step2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var sms_status: UILabel!
    
    @IBOutlet weak var valid: UILabel!
    @IBOutlet weak var editProfile: UIButton!
    var picker: [String] = [String]()
    var contact_id : [Int] = [Int]()
    var contact_status: [Int] = [Int]()
    var contact_phone : [String] = [String]()
    @IBOutlet weak var add_contact: UIButton!
    @IBOutlet weak var contactPicker: UIPickerView!
    @IBOutlet weak var selectedContact: UILabel!
    @IBAction func checkAvailability(_ sender: Any) {
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/check_contact_availability?id=\(contact_id[contactPicker.selectedRow(inComponent: 0)])")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: checkAvailCallback)
    }
    
    func checkAvailCallback(data: JSON){
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactPicker.delegate = self
        self.contactPicker.dataSource = self
        print("Step 2 View Controller")
        self.editProfile.setTitle(TaskGlobalStorage.user_first_name, for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func remove_contact(_ sender: Any) {
        print ("remove contact button hit")
        print (contactPicker.selectedRow(inComponent: 0))
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/delete_contact?id=\(contact_id[contactPicker.selectedRow(inComponent: 0)])")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: removeCallback)
    }
    func removeCallback(data: JSON){
        loadData()
    }

    @IBAction func add_contact_func(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Contact", message: "Enter your person", preferredStyle: .alert)
        
        alert.addTextField { (textField_contact_first_name) in
            textField_contact_first_name.placeholder = "Enter new contact person first name"
        }
        
        alert.addTextField { (textField_contact_last_name) in
            textField_contact_last_name.placeholder = "Enter new contact person last name"
        }
        
        alert.addTextField { (textField_relationship) in
            textField_relationship.placeholder = "Enter your relationship"
        }
        
        alert.addTextField { (textField_contact_phone) in
            textField_contact_phone.placeholder = "Enter your person's phone number"
        }
        
        alert.addTextField { (textField_contact_email) in
            textField_contact_email.placeholder = "Enter your person's email"
        }
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "Send Request", style: .default, handler: { [weak alert] (_) in
            
            var textField_contact_first_name = ""
            var textField_contact_last_name = ""
            var textField_relationship = ""
            var textField_contact_phone = ""
            var textField_contact_email = ""
            
            
            if let value = alert?.textFields![0].text{
                textField_contact_first_name = value
            }
            
            if let value = alert?.textFields![1].text{
                textField_contact_last_name = value
            }
            
            if let value = alert?.textFields![2].text{
                textField_relationship = value
            }
            if let value = alert?.textFields![3].text{
                textField_contact_phone = value
            }
            if let value = alert?.textFields![4].text{
                textField_contact_email = value
            }
            
            
            let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/add_new_contact")
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            let postString = "contact_first_name=\(textField_contact_first_name)&contact_last_name=\(textField_contact_last_name)&contact_relationship=\(textField_relationship)&contact_phone=\(textField_contact_phone)&contact_email=\(textField_contact_email)&user_first_name=\(TaskGlobalStorage.user_first_name)"
            print (postString)
            request.httpBody = postString.data(using: .utf8)
            
            HTTP.request(request: request, callback: self.post_new_contact)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    func post_new_contact(data : JSON){
        print (data)
        DispatchQueue.main.async {
            print ("bitch ass")
            if (data["success"] == true){
            print (data["validation_errors"])
                self.valid.text = "Your request to the contact has been sent. Please navigate to your profile > Contact Statuses for all pending and accepted contacts"
//                for i in 0..<(data["validation_errors"].array)!.count{
//                    self.valid.text! += (data["validation_errors"][i].string)! + "\n"
            }
            else {
            self.valid.text = " "
            for i in 0..<(data["validation_errors"].array)!.count{
            self.valid.text! += (data["validation_errors"][i].string)! + "\n"
            }
        }
        }
        loadData()
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

func loadData(){
    var url = URL(string: "http://\(TaskGlobalStorage.ip_add)/display_contacts")
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

func loadDataCallback(JSON_response: JSON){
    self.picker = []
    self.contact_id = []
    self.contact_status = []
    self.contact_phone = []
    
    
    print("loadDataCallback")
    print(JSON_response)
    print(JSON_response["data"].count)
    
    for index in 0..<JSON_response["data"].count{
        var toAppend = JSON_response["data"][index]["contact_first_name"]
        var toAppend2 = JSON_response["data"][index]["contact_last_name"]
        var toAppendContactId = JSON_response["data"][index]["id"]
        var toAppendContactPhone = JSON_response["data"][index]["contact_phone"]
        var toAppendContactStatus = JSON_response["data"][index]["contact_status"]
        
        if (toAppendContactStatus == 1){
            self.picker.append(toAppend.string! + " " + toAppend2.string!)
//            self.picker.append()
            self.contact_id.append(toAppendContactId.int!)
            self.contact_phone.append(toAppendContactPhone.string!)
            self.contact_status.append(toAppendContactStatus.int!)
        }
    }
    
    if(self.picker.count > 0){
        TaskGlobalStorage.emergency_contact_name = self.picker[0]
        self.selectedContact.text = "Selected Contact: \(self.picker[0])"
        TaskGlobalStorage.emergency_contact_id = contact_id[0]
        TaskGlobalStorage.emergency_contact_phone = contact_phone[0]
    }
    
    print("picker arr:")
    print(self.picker)
    
    DispatchQueue.main.async {
        self.contactPicker.reloadAllComponents()
    }
}

override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    self.valid.text = " ";
    loadData()
}


// Picker View funcs:
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.picker.count
    print ("fuck")
    print (self.picker.count)
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.picker[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    TaskGlobalStorage.emergency_contact_name = self.picker[row]
    TaskGlobalStorage.emergency_contact_id = contact_id[row]
    TaskGlobalStorage.emergency_contact_phone = contact_phone[row]
    self.selectedContact.text = "Selected Contact: \(self.picker[row])"
    print (TaskGlobalStorage.emergency_contact_name)
    print(TaskGlobalStorage.emergency_contact_id)
    print(TaskGlobalStorage.emergency_contact_phone)
    }
}


