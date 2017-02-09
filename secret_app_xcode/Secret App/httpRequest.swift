//
//  httpRequest.swift
//  Secret App
//
//  Created by Queenie Ho on 2/8/17.
//  Copyright © 2017 SecretApp. All rights reserved.
//

import Foundation

public class HTTP
{
    public class func request(request: URLRequest, callback: @escaping ((_ JSON_response: JSON) -> Void))
    {
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
            //            print("responseString = \(responseString)")
            
//            let cookies = HTTPCookieStorage.shared.cookies(for: (response?.url!)!)
//            print("cookies:\(cookies)")
            
            let JSON_response = JSON(data)
            callback(JSON_response)
        }
        task.resume()
    }
}
