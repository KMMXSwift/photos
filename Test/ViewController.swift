//
//  ViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 10/24/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var focusedView: UITextField?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func changeText(sender: UIButton)
    {
        helloLabel.text = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        focusedView = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        focusedView?.resignFirstResponder()
        
        return true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}