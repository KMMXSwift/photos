//
//  ThirdViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/7/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ThirdViewController: UIViewController, CLLocationManagerDelegate
{
    @IBOutlet weak var coordinateLabel: UILabel!
    @IBOutlet weak var gyroscopeLabel: UILabel!
    @IBOutlet weak var accelerometerLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    let motionQueue = NSOperationQueue()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse)
        {
            locationManager.startUpdatingLocation()
        }
        else
        {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        switch (status)
        {
        case .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("User didn't authorize location use :(")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.coordinateLabel.text = "Lat: \(location.coordinate.latitude) long: \(location.coordinate.longitude)"
            })
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        let frame = CGRect(x: view.bounds.midX - 50.0, y: view.bounds.midY - 50.0, width: 100.0, height: 100.0)
        
        let childView = UIView(frame: frame)
        childView.backgroundColor = UIColor(red: 40.0/255.0, green: 121.0/255.0, blue: 75.0/255.0, alpha: 1.0)
        //childView.layer.borderColor = UIColor.yellowColor().CGColor
        //childView.layer.borderWidth = 3.0
        childView.layer.shadowColor = UIColor.darkGrayColor().CGColor
        childView.layer.shadowOffset = CGSize(width: 2.0, height: 8.0)
        childView.layer.shadowOpacity = 0.5
        childView.layer.shadowRadius = 2.0
        view.addSubview(childView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("animate:"))
        tapGestureRecognizer.numberOfTapsRequired = 2
        childView.addGestureRecognizer(tapGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: Selector("animatePinch:"))
        childView.addGestureRecognizer(pinchGestureRecognizer)
        
        motionManager.accelerometerUpdateInterval = 2.0
        
        motionManager.startAccelerometerUpdatesToQueue(motionQueue) { (data: CMAccelerometerData?, error: NSError?) -> Void in
            
            if let error = error
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.accelerometerLabel.text = error.debugDescription
                })
            }
            else if let data = data
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.accelerometerLabel.text = "X: \(data.acceleration.x) Y: \(data.acceleration.y) Z: \(data.acceleration.z)"
                })
            }
        }
        
        motionManager.gyroUpdateInterval = 2.0
        
        motionManager.startGyroUpdatesToQueue(motionQueue) { (data: CMGyroData?, error: NSError?) -> Void in
            
            if let error = error
            {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.gyroscopeLabel.text = error.debugDescription
                })
            }
            else
            {
                if let data = data
                {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.gyroscopeLabel.text = "X: \(data.rotationRate.x) Y: \(data.rotationRate.y) Z: \(data.rotationRate.z)"
                    })
                }
            }
        }
    }
    
    func animate(sender: UITapGestureRecognizer)
    {
        /*
        if let view = sender.view
        {
        UIView.animateWithDuration(5.0) { () -> Void in
        view.center = self.view.frame.origin
        }
        }
        */
        
        if let animatedView = sender.view
        {
            let fromValue = NSValue(CGPoint: animatedView.layer.position)
            let toValue = NSValue(CGPoint: view.frame.origin)
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = fromValue
            animation.toValue = toValue
            animation.duration = 5.0
            animatedView.layer.addAnimation(animation, forKey: "position")
            
            animatedView.center = toValue.CGPointValue()
        }
    }
    
    func animatePinch(sender: UIPinchGestureRecognizer)
    {
        if let view = sender.view
        {
            let scaleTransform = CGAffineTransformMakeScale(2.0, 2.0)
            let rotationTransform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
            let transform = CGAffineTransformConcat(scaleTransform, rotationTransform)
            
            UIView.animateWithDuration(3.0, animations: { () -> Void in
                view.transform = transform
            })
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension UIColor
{
    convenience init(hex: Int, alpha: CGFloat)
    {
        self.init(red: CGFloat((hex >> 16) & 0xff) / 255.0, green: CGFloat((hex >> 8) & 0xff) / 255.0, blue: CGFloat(hex & 0xff) / 255.0, alpha: alpha)
    }
}