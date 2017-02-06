import UIKit

class RegistrationController: UIViewController {
    
    @IBOutlet weak var reg_button: UIButton!
    
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm_password: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("registration controller")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func to_reg(_ sender: UIButton) {
//        let user_inputs = [
//            "first_name" : first_name.text!,
//            "last_name" : last_name.text!,
//            "email" : email.text!,
//            "password" : password.text!,
//            "confirm_password" : confirm_password.text!]
//        as [String : Any?]

//        print (JSON(user_inputs))
//        let user_inputs_json (JSON(user_inputs).rawString([.castNilToNSNull: true]))
        
        var request = URLRequest(url: URL(string: "http://localhost:5000/registration")!)
        request.httpMethod = "POST"
        let postString = "first_name=\(first_name.text!)&last_name=\(last_name.text!)&email=\(email.text!)&password=\(password.text!)&confirm_password=\(confirm_password.text!)&phone=\(phone.text!)"
        print (postString)
        request.httpBody = postString.data(using: .utf8)
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
            print("responseString = \(responseString)")
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
