//
//  editProfileViewController.swift
//  Secret App
//
//  Created by Queenie Ho on 2/17/17.
//  Copyright © 2017 SecretApp. All rights reserved.
//

import Foundation
import UIKit


class editProfileViewController: UIViewController {
    func post_edit_profile(data : JSON){
        print (data)
        
        DispatchQueue.main.async {
            self.validation.textColor = UIColor.green
            self.validation.text = "Your changes have been made"
        }
    

    }
    @IBOutlet weak var validation: UILabel!
    
    @IBAction func submitChanges(_ sender: Any) {
        validation.textColor = UIColor.red
        if (newPassword.text != newConfirmPassword.text!){
            validation.text = "passwords ain't matching. You need glasses?"
        }
        else if ((newFirstName.text?.isEmpty)! && (newLastName.text?.isEmpty)! && (newPhoneNumber.text?.isEmpty)! && (neEmail.text?.isEmpty)! && (newConfirmPassword.text?.isEmpty)!){
            validation.text = "you need to actually edit to change your profile. Duh"
        }
        else {
            validation.text = ""
            let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/edit_profile")
            
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            
            let postString = "first_name=\(newFirstName.text!)&last_name=\(newLastName.text!)&phone=\(newPhoneNumber.text!)&email=\(neEmail.text!)&password=\(newConfirmPassword.text!)"
            print (postString)
            request.httpBody = postString.data(using: .utf8)
            
            HTTP.request(request: request, callback: self.post_edit_profile)

        }
    }
    
    @IBOutlet weak var neEmail: UITextField!
    @IBOutlet weak var newConfirmPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPhoneNumber: UITextField!
    @IBOutlet weak var newLastName: UITextField!
    @IBOutlet weak var newFirstName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("edit task View Controller")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)

        
        newFirstName.placeholder = TaskGlobalStorage.user_first_name
        newLastName.placeholder = TaskGlobalStorage.user_last_name
        neEmail.placeholder = TaskGlobalStorage.user_email
        newPhoneNumber.placeholder = TaskGlobalStorage.user_number
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

