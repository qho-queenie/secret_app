import UIKit

class Step1ViewController: UIViewController {
    
    @IBOutlet weak var eventPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Step 1 View Controller")
        
//        let auth = "?id=\(LoginSession["id"])&unique_key=\(LoginSession["unique_key"])"
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
            print("responseString = \(responseString)")
            
            let cookies = HTTPCookieStorage.shared.cookies(for: (response?.url!)!)
            print("cookies:\(cookies)")
        
        }
        task.resume()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
