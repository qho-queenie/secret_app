import UIKit



class LoginController: UIViewController {


    @IBOutlet weak var no_record: UILabel!
    @IBOutlet weak var validation: UILabel!
    @IBOutlet weak var password_login: UITextField!
    @IBOutlet weak var email_login: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    var backButtonTitle = "Back";
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = backButtonTitle
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {

        var request = URLRequest(url: URL(string: "http://\(TaskGlobalStorage.ip_add)/login")!)
        request.httpMethod = "POST"
        print (request)
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
                    self.backButtonTitle = "Logout"
                    self.performSegue(withIdentifier: "LoginSegue", sender: self.loginButton)
                }
                else {
                    print ((json["validation_errors"][0].string)!)
                    self.validation.text = " "
                    self.no_record.text = " "
                    for index in 0..<(json["validation_errors"].array)!.count {
                        self.validation.text! += (json["validation_errors"][index].string)!
                    }
                }
            }
        })
        task.resume()
        
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Forgot Password", message: "Enter your email to retrieve your password", preferredStyle: .alert)
        
        alert.addTextField { (textField_retrieve_email) in
            textField_retrieve_email.placeholder = "Enter your email"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
        }))
        
        alert.addAction(UIAlertAction(title: "Send Request", style: .default, handler: { [weak alert] (_) in
            
            var textField_retrieve_email : String = ""
            
            if let value = alert?.textFields![0].text{
                textField_retrieve_email = value
            }
            
            print ("fuck")
            
            let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/retrieve_password")
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"

            let postString = "email=\(textField_retrieve_email)"
            request.httpBody = postString.data(using: .utf8)
            print ("fuck")
            print (postString)
            HTTP.request(request: request, callback: self.post_retrieve_password)

        }))
        self.present(alert, animated: true, completion: nil)
    }

    func post_retrieve_password(data: JSON){
        print(data["validation_errors"])
        DispatchQueue.main.async {
            self.no_record.text = " "
            self.validation.text = " "
        for index in 0..<data["validation_errors"].count{
            let toAppend = data["validation_errors"][index]
            print("the error is:\(toAppend)")
            if (toAppend == "Please check your email."){
                self.no_record.text! += (toAppend.string)!
            }
            else {
                self.no_record.text! += (toAppend.string)!
            }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if(TaskGlobalStorage.user_id == 0)
        {
            validation.text = "Please log in again."
        }
        self.backButtonTitle = "Back";
        TaskGlobalStorage.user_id = -1;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("login controller")

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height/4)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


}

