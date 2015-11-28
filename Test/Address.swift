//
//  Address.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/21/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import CoreLocation

class Address: NSObject
{
    var street = ""
    var suite = ""
    var city = ""
    var zipcode = ""
    var geo: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.413024, longitude: -99.165761)
    
    convenience init(street: String, suite: String, city: String, zipcode: String, geo: CLLocationCoordinate2D)
    {
        self.init()
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
    
    class func parseAddress(rawAddress: [String: AnyObject]) -> Address
    {
        let street = rawAddress["street"] as! String
        let suite = rawAddress["suite"] as! String
        let city = rawAddress["city"] as! String
        let zipcode = rawAddress["zipcode"] as! String
        
        let rawGeo = rawAddress["geo"] as! [String: String]
        let latitude = Double(rawGeo["lat"]!)
        let longitude = Double(rawGeo["lng"]!)
        let geo = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        return Address(street: street, suite: suite, city: city, zipcode: zipcode, geo: geo)
    }
}
