//
//  Protocols.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/14/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import Foundation

protocol Hello
{
    func helloWorld()
}

extension Hello
{
    func helloWorld()
    {
        print("Hello World")
    }
}

protocol HelloMars
{
    func helloMars()
}

extension HelloMars
{
    func helloMars()
    {
        print("Hello Mars")
        helloMars()
    }
}