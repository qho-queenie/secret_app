//
//  HowToViewController.swift
//  Secret App
//
//  Created by Chris Rollins on 3/9/17.
//  Copyright © 2017 SecretApp. All rights reserved.
//

import Foundation
import UIKit

class HowToViewController: UIViewController {
    @IBAction func link(_ sender: Any) {
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : true]
        UIApplication.shared.open(URL(string: "https://usafesite.netlify.com/")!, options: [:], completionHandler: nil)
    }
    
    @IBOutlet weak var contentLabel: UILabel!

    override func viewDidLoad() {
        contentLabel.layer.borderColor = UIColor.white.cgColor
        contentLabel.layer.borderWidth = 1.0
        super.viewDidLoad()
        self.contentLabel.text = "1. Register for an account\n\n2. Add a few friends or family as your emergency contacts.\n\n3. Configure your upcoming task.\n\n4. Set the duration of your chosen task.\n\n5. If your contact is available, you can start the task's countdown.\n\n6. When your task is finish, check back in the app with the \"stop\" button to let your contact know that you are safe.\n\n7. If you have not checked back in before the countdown ends, your contact will receive a text message to make sure you are safe."
    }
}
