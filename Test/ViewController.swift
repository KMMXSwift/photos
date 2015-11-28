//
//  ViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 10/24/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SecondViewControllerDelegate
{
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var focusedView: UITextField?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let url = NSBundle.mainBundle().URLForResource("music", withExtension: "m4a")
        {
            let playerItem = AVPlayerItem(URL: url)
            let player = AVPlayer(playerItem: playerItem)
            player.play()
        }
        
        NSUserDefaults.standardUserDefaults().setObject("KMMX", forKey: "name")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        User.getUser(1) { (user) -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.helloLabel.text = "Hello, \(user.name)!"
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "SecondSegue")
        {
            let vc = segue.destinationViewController as! SecondViewController
            vc.delegate = self
        }
    }
    
    func didSelectItem(name: String)
    {
        helloLabel.text = name
        
        NSNotificationCenter.defaultCenter().postNotificationName("selectItem", object: nil, userInfo: ["name": name])
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
    
    @IBAction func takeAPicture(sender: UIButton)
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        
        if let availableModes = UIImagePickerController.availableCaptureModesForCameraDevice(UIImagePickerControllerCameraDevice.Rear)
        {
            if (availableModes.count > 0)
            {
                if (availableModes.contains(UIImagePickerControllerCameraCaptureMode.Photo.rawValue))
                {
                    imagePickerVC.sourceType = UIImagePickerControllerSourceType.Camera
                    //imagePickerVC.mediaTypes = [String(kUTTypeMovie)]
                    imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.Photo
                    imagePickerVC.cameraDevice = UIImagePickerControllerCameraDevice.Rear
                    imagePickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Auto
                }
            }
        }
        
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        /*
        if let documents = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        {
            let url = NSURL(fileURLWithPath: documents).URLByAppendingPathComponent("picture.png")
            let saved = UIImagePNGRepresentation(image)?.writeToURL(url, atomically: true)
            
            print("Saved image: \(saved)")
        }
        */
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didFinishSaving()
    {
        print("Saved to photos album")
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}