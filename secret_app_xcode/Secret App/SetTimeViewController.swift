import UIKit

class SetTimeViewController: UIViewController {

    @IBAction func timeInputChange(_ sender: Any) {
        print((sender as AnyObject).text!)
        TaskGlobalStorage.minutes = (sender as AnyObject).text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Step 3 View Controller")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
