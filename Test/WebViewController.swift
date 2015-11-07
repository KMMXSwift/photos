//
//  WebViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/7/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate
{
    @IBOutlet weak var webView: UIWebView!
    
    var url: NSURL?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let url = url
        {
            let request = NSURLRequest(URL: url)
            /*
            request.HTTPMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body = ["email": "me@richiereyes.com", "password": "123456"]
            
            do
            {
                let data = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
                request.HTTPBody = data
            }
            
            catch
            {
                print("JSON serialization failed")
            }
            */
            
            webView.loadRequest(request)
            
            self.title = "\(url)"
        }
    }

    @IBAction func share(sender: UIBarButtonItem)
    {
        if let url = url
        {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        else
        {
            let alertVC = UIAlertController(title: "Invalid URL", message: "Check if your URL is valid.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okay = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction) -> Void in
                
            })
            
            alertVC.addAction(okay)
            
            self.presentViewController(alertVC, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
