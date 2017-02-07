import UIKit



class LoginController: UIViewController {

    @IBOutlet weak var password_login: UITextField!
    @IBOutlet weak var email_login: UITextField!
    @IBOutlet weak var login_button: UIButton!
    
    @IBAction func login_touch(_ sender: Any) {
        print (password_login.text)
        print (email_login.text)
        
        var request = URLRequest(url: URL(string: "http://localhost:5000/login")!)
        request.httpMethod = "POST"
        let postString = "email=\(email_login.text!)&password=\(password_login.text!)"
        print (postString)
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            var httpResponse: HTTPURLResponse = response as! HTTPURLResponse
            
            // Since the incoming cookies will be stored in one of the header fields in the HTTP Response, parse through the header fields to find the cookie field and save the data
            
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: httpResponse.allHeaderFields as! [String : String], for: (response?.url!)!) as! [HTTPCookie]
            
            HTTPCookieStorage.shared.setCookies(cookies as [AnyObject] as! [HTTPCookie], for: response?.url!, mainDocumentURL: nil)
            
//            print ("hi")
//            print (cookies)

            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
//            print (self)
//            self.segueToNext()
            
            
        }
        task.resume()
        
        print ("after resume")
        
    }
    
//    func segueToNext(){
//        performSegue(withIdentifier: "mySegueID", sender: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("login controller")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

