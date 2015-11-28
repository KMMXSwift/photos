//
//  ConnectionManager.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/21/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class ConnectionManager: NSObject
{
    var session = NSURLSession.sharedSession()
    
    convenience init(session: NSURLSession)
    {
        self.init()
        self.session = session
    }
    
    class func connect(uri: String, method: String, body: AnyObject?, completionHandler: (response: AnyObject) -> ())
    {
        if let url = NSURL(string: uri)
        {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = method
            
            if let body = body
            {
                do
                {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
                }
                
                catch
                {
                    print("JSON Serialization failed")
                }
            }
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (responseData: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                if let error = error
                {
                    print("Error: \(error)")
                }
                else
                {
                    if let data = responseData
                    {
                        do
                        {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                            
                            completionHandler(response: responseObject)
                        }
                        
                        catch
                        {
                            print("Response serialization failed")
                        }
                    }
                }
            })
            
            dataTask.resume()
        }
    }
}
