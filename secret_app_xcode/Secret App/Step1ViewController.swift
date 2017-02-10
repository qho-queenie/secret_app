import UIKit

class Step1ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

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
        
//        loadData()
    }
    
    func loadData(){
        let url = URL(string: "http://localhost:5000/display_events")
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            //            print("responseString = \(responseString)")
            
            let cookies = HTTPCookieStorage.shared.cookies(for: (response?.url!)!)
            print("cookies:\(cookies)")
            
            var JSON_response = JSON(data)
            
            var path : [JSONSubscriptType] = ["data", 0]
            print ("fuck")
            //            print (JSON_response["data"][0])
            //
            print (JSON_response)
            
            self.picker = []
            self.public_event_id = []
            
            for index in 0..<JSON_response["data"].count{
                var toAppend = JSON_response["data"][index]["event_name"]
                var toAppendEventId = JSON_response["data"][index]["id"]
                path = ["data", index]
                print ("fuck off")
                print(JSON_response["data"][index]["id"].int)
                self.picker.append(toAppend.string!)
                self.public_event_id.append(toAppendEventId.int!)
            }
            
            print (self.public_event_id)
            print (self.picker)
            
            self.eventPicker.reloadAllComponents()
        }
        task.resume()
    }
    
    @IBAction func remove_task_action(_ sender: UIButton) {
        print ("fuck")
        print (eventPicker.selectedRow(inComponent: 0))
        
        let url = URL(string: "http://localhost:5000/delete_event?id=\(public_event_id[eventPicker.selectedRow(inComponent: 0)])")
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"

        HTTP.request(request: request, callback: removeCallback)
    }
    
    func removeCallback(data: JSON)
    {
        print(data)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    @IBAction func add_event_func(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add New Event", message: "Enter an event", preferredStyle: .alert)
        
        alert.addTextField { (textField_event_name) in
            textField_event_name.text = "Enter new event name here"
        }
        
        alert.addTextField { (textField_event_note) in
            textField_event_note.text = "Enter event's note here(optional)"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let textField_event_name = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            var textField_event_name = ""
            var textField_event_note = ""
            
            if let value = alert?.textFields![0].text{
                textField_event_name = value
            }
            
            if let value = alert?.textFields![1].text{
                textField_event_note = value
            }
            
            let url = URL(string: "http://localhost:5000/add_new_event")
            
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return picker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return picker[row]
    }
    
}
