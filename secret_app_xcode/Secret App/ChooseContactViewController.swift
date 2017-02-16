import UIKit

class Step2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    var picker: [String] = [String]()
    var contact_id : [Int] = [Int]()
    var contact_phone : [String] = [String]()
    @IBOutlet weak var add_contact: UIButton!
    @IBOutlet weak var contactPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactPicker.delegate = self
        self.contactPicker.dataSource = self
        print("Step 2 View Controller")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func remove_contact(_ sender: Any) {
        //ADD THIS
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
            
            
            let url = URL(string: "http://localhost:5000/add_new_contact")
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            let postString = "contact_first_name=\(textField_contact_first_name)&contact_last_name=\(textField_contact_last_name)&contact_relationship=\(textField_relationship)&contact_phone=\(textField_contact_phone)&contact_email=\(textField_contact_email)"
            print (postString)
            request.httpBody = postString.data(using: .utf8)
            
            HTTP.request(request: request, callback: self.post_new_contact)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    func post_new_contact(data : JSON){
        loadData()
    }

func loadData(){
    let url = URL(string: "http://localhost:5000/display_contacts")
    var request = URLRequest(url: url!)
    request.httpMethod = "GET"
    HTTP.request(request: request, callback: loadDataCallback)
}

func loadDataCallback(JSON_response: JSON){
    self.picker = []
    
    print("loadDataCallback")
    print(JSON_response)
    
    for index in 0..<JSON_response["data"].count{
        var toAppend = "\(JSON_response["data"][index]["contact_first_name"].string!) \(JSON_response["data"][index]["contact_last_name"].string!)"
        var toAppendContactId = JSON_response["data"][index]["id"]
        var toAppendContactPhone = JSON_response["data"][index]["contact_phone"]
        self.picker.append(toAppend)
        self.contact_id.append(toAppendContactId.int!)
        self.contact_phone.append(toAppendContactPhone.string!)
    }
    
    print("picker arr:")
    print(self.picker)
    
    DispatchQueue.main.async {
        self.contactPicker.reloadAllComponents()
    }
}

override func viewWillAppear(_ animated: Bool) {
    loadData()
}


// Picker View funcs:
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.picker.count
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.picker[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    TaskGlobalStorage.emergency_contact_name = self.picker[row]
    TaskGlobalStorage.emergency_contact_id = contact_id[row]
    TaskGlobalStorage.emergency_contact_phone = contact_phone[row]
    print (TaskGlobalStorage.emergency_contact_name)
    print(TaskGlobalStorage.emergency_contact_id)
    print(TaskGlobalStorage.emergency_contact_phone)
    }
}


