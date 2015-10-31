//
//  SecondViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 10/24/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    let downloadQueue = dispatch_queue_create("downloadQueue", DISPATCH_QUEUE_CONCURRENT)
    
    let photos = Photo.getPhotos()
    let cache = NSCache()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let photos = self.photos
        {
            return photos.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoTableViewCell
        
        if let photo = photos?[indexPath.row]
        {
            cell.nameLabel.text = photo.name
            
            if let cacheImage = cache.objectForKey(indexPath.row) as? UIImage
            {
                cell.photoImageView.image = cacheImage
            }
            else
            {
                cell.activityIndicator.startAnimating()
                
                dispatch_async(downloadQueue, { () -> Void in
                    
                    if let image = Photo.cachePhoto(photo)
                    {
                        self.cache.setObject(image, forKey: indexPath.row)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.photoImageView.image = image
                            cell.activityIndicator.stopAnimating()
                        })
                    }
                })
            }
        }
        
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
