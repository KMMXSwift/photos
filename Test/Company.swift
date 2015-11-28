//
//  Company.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/21/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class Company: NSObject
{
    var name = ""
    var catchphrase = ""
    var bs = ""
    
    convenience init (name: String, catchphrase: String, bs: String)
    {
        self.init()
        self.name = name
        self.catchphrase = catchphrase
        self.bs = bs
    }
    
    class func parseCompany(rawCompany: [String: String]) -> Company
    {
        let name = rawCompany["name"]
        let catchphrase = rawCompany["catchPhrase"]
        let bs = rawCompany["bs"]
        
        return Company(name: name!, catchphrase: catchphrase!, bs: bs!)
    }
}
