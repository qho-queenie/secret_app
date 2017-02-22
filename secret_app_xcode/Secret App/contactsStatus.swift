//
//  contactsStatusTableView.swift
//  Secret App
//
//  Created by Queenie Ho on 2/17/17.
//  Copyright © 2017 SecretApp. All rights reserved.
//

import Foundation
import UIKit



class contactsStatusTableView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var displayCell: UILabel!
    
    var forDisplay : [String] = [String]()
    

    @IBOutlet weak var contact_status_table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Set Time View Controller")
        contact_status_table.delegate = self
        contact_status_table.dataSource = self
        
        self.contact_status_table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

    }
    override func viewWillAppear(_ animated: Bool) {
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
        
        if let unwrapped = JSON_response["data"][0]["first_name"].string {
        }
        if let unwrapped = JSON_response["data"][0]["email"].string {
        }
        if let unwrapped = JSON_response["data"][0]["phone"].string {
        }
        
        DispatchQueue.main.async {

            for index in 0..<JSON_response["data"].count{
                var first_name = JSON_response["data"][index]["contact_first_name"].string ?? ""
                var email = JSON_response["data"][index]["contact_email"].string ?? ""
                var phone = JSON_response["data"][index]["contact_phone"].string ?? ""
                
                var all = first_name + email + phone
                
                
                print("contact's everything:\(all)")
                
                self.forDisplay.append(all)
            }
            self.contact_status_table.reloadData()
        }
        

    }
    

    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("number of rows")
        if (forDisplay.count == 0){
            print ("0")
        }
        return forDisplay.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell")!
        
        cell.textLabel?.text = self.forDisplay[indexPath.row]
        print ("bitch")
        print (forDisplay[indexPath.row])
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
