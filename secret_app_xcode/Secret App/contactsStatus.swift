//
//  contactsStatusTableView.swift
//  Secret App
//
//  Created by Queenie Ho on 2/17/17.
//  Copyright © 2017 SecretApp. All rights reserved.
//

import Foundation
import UIKit


class cellClass: UITableViewCell {
    @IBOutlet weak var first: UILabel!

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var status: UILabel!
}

class contactsStatusTableView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var displayCell: UILabel!
    
    var display_first : [String] = [String]()
    var display_email : [String] = [String]()
    var display_status : [String] = [String]()
    

    @IBOutlet weak var contact_status_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Set Time View Controller")
        contact_status_table.delegate = self
        contact_status_table.dataSource = self
        
//        self.contact_status_table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        loadData()
    }
    
    func loadData(){
        let url = URL(string: "http://\(TaskGlobalStorage.ip_add)/display_contacts")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        HTTP.request(request: request, callback: loadDataCallback)
    }
    
    func loadDataCallback(JSON_response: JSON){
        print("loadDataCallback")
        print(JSON_response)
        

        DispatchQueue.main.async {

            
            for index in 0..<JSON_response["data"].count{
                print ("hello")
//                print (JSON_response["data"][index]["contact_phone"].int!)
                
                var first_name = JSON_response["data"][index]["contact_first_name"].string ?? "" + " "

                var email = JSON_response["data"][index]["contact_phone"].string ?? "" + " "


//                var phone = JSON_response["data"][index]["contact_phone"].string ?? ""
                
                var statuses = JSON_response["data"][index]["contact_status"].int ?? 0
                var stat = " "

                if (statuses == 0){
                    stat = "pending"
                }
                else if (statuses == 1){
                    stat = "accepted"
                }
                else if (statuses == 2){
                    stat = "declined"
                }
                print ("aaaaa")
                print (statuses)
                
                var all = "\(first_name)  \(email)  \(stat)"
                print ("hello")

                print("contact's everything:\(all)")

                self.display_first.append(first_name)
                self.display_email.append(email)
                self.display_status.append(stat)
            }
            self.contact_status_table.reloadData()
        }
        

    }
    

    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("number of rows")
        if (display_first.count == 0){
            print ("0")
        }
        return display_first.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")! as! cellClass
        
        cell.first?.text = self.display_first[indexPath.row]
        cell.email?.text = self.display_email[indexPath.row]
        cell.status?.text = self.display_status[indexPath.row]
        print ("bitch")

        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
