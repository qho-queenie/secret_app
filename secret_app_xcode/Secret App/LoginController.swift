import UIKit



class LoginController: UIViewController {


    @IBOutlet weak var validation: UILabel!
    @IBOutlet weak var password_login: UITextField!
    @IBOutlet weak var email_login: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: Any) {

        var request = URLRequest(url: URL(string: "http://\(TaskGlobalStorage.ip_add)/login")!)
        request.httpMethod = "POST"
        let postString = "email=\(email_login.text!)&password=\(password_login.text!)"
//        print (postString)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request,
                                    completionHandler: { (data, response, error) in
            
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            var httpResponse: HTTPURLResponse = response as! HTTPURLResponse
            
            // Since the incoming cookies will be stored in one of the header fields in the HTTP Response, parse through the header fields to find the cookie field and save the data

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
            let json = JSON(data)
            
            let cookies = HTTPCookieStorage.shared.cookies(for: (response?.url!)!)
            print("cookies:\(cookies)")
            
            DispatchQueue.main.async {
                print("segue after HTTP response")
                print (json)
                
                if (json["success"].bool! == true){
                    self.performSegue(withIdentifier: "LoginSegue", sender: self.loginButton)
                }
                else {
                    print ((json["validation_errors"][0].string)!)
                    self.validation.text = " "
                    for index in 0..<(json["validation_errors"].array)!.count {
                        self.validation.text! += (json["validation_errors"][index].string)!
                    }
                }
            }
        })
        task.resume()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("login controller")
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        
//        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
//    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }


}

