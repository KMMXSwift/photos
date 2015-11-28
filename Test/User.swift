//
//  User.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/21/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class User: NSObject
{
    var userID = 0
    var name = ""
    var username = ""
    var email = ""
    var address: Address = Address()
    var phone = ""
    var website = ""
    var company: Company = Company()
    
    convenience init(userID: Int, name: String, username: String, email: String, address: Address, phone: String, website: String, company: Company)
    {
        self.init()
        self.userID = userID
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
    
    class func getUser(userID: Int, completionHandler: (user: User) -> ())
    {
        let uri = "http://jsonplaceholder.typicode.com/users/\(userID)"
        
        ConnectionManager.connect(uri, method: "GET", body: nil) { (response) -> () in
            
            if let rawUser = response as? [String: AnyObject]
            {
                let user = User.parseUser(rawUser)
                completionHandler(user: user)
            }
        }
    }
    
    class func parseUser(rawUser: [String: AnyObject]) -> User
    {
        let userID = rawUser["id"] as! Int
        let name = rawUser["name"] as! String
        let username = rawUser["username"] as! String
        let email = rawUser["email"] as! String
        let rawAddress = rawUser["address"] as? [String: AnyObject]
        let address = Address.parseAddress(rawAddress!)
        let phone = rawUser["phone"] as! String
        let website = rawUser["website"] as! String
        let rawCompany = rawUser["company"] as! [String: String]
        let company = Company.parseCompany(rawCompany)
        
        return User(userID: userID, name: name, username: username, email: email, address: address, phone: phone, website: website, company: company)
    }
}
