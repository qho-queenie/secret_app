import UIKit

class SetTimeViewController: UIViewController {

    @IBOutlet weak var editProfile: UIButton!
    @IBAction func timeInputChange(_ sender: Any) {
        print((sender as AnyObject).text!)
        TaskGlobalStorage.minutes = (sender as AnyObject).text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print("Set Time View Controller")
            self.editProfile.setTitle(TaskGlobalStorage.user_first_name, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
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
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    
    
}
