//
//  startView.swift
//  Secret App
//
//  Created by Queenie Ho on 3/1/17.
//  Copyright © 2017 SecretApp. All rights reserved.
//

import UIKit

class startViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("first View Controller")
        self.navigationItem.backBarButtonItem?.title = "Logout"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



