//
//  SecondViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 10/24/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let downloadQueue = dispatch_queue_create("downloadQueue", DISPATCH_QUEUE_CONCURRENT)
    
    var photos: [Photo] = []
    let cache = NSCache()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let caches = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        {
            let fileURL = NSURL(fileURLWithPath: caches).URLByAppendingPathComponent("photos.sicop")
            
            if (NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!))
            {
                if let photos = NSKeyedUnarchiver.unarchiveObjectWithFile(fileURL.path!) as? [Photo]
                {
                    self.photos = photos
                    tableView.reloadData()
                    collectionView.reloadData()
                }
            }
            else
            {
                if let photos = Photo.getPhotos()
                {
                    self.photos = photos
                    tableView.reloadData()
                    collectionView.reloadData()
                    
                    let saved = NSKeyedArchiver.archiveRootObject(photos, toFile: fileURL.path!)
                    print("Saved photos: \(saved)")
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoTableViewCell
        
        cellData(indexPath.row, cell: cell)
        
        return cell
    }
    
    func cellData(index: Int, cell: UIView)
    {
        let photo = photos[index]
        
        if let cacheImage = cache.objectForKey(index) as? UIImage
        {
            if let cell = cell as? PhotoTableViewCell
            {
                cell.nameLabel.text = photo.name
                cell.photoImageView.image = cacheImage
            }
            else if let cell = cell as? PhotoCollectionViewCell
            {
                cell.imageView.image = cacheImage
            }
        }
        else
        {
            if let cell = cell as? PhotoTableViewCell
            {
                cell.activityIndicator.startAnimating()
            }
            else if let cell = cell as? PhotoCollectionViewCell
            {
                cell.activityIndicator.startAnimating()
            }
            
            dispatch_async(downloadQueue, { () -> Void in
                
                if let image = Photo.cachePhoto(photo)
                {
                    self.cache.setObject(image, forKey: index)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        if let cell = cell as? PhotoTableViewCell
                        {
                            cell.photoImageView.image = image
                            cell.activityIndicator.stopAnimating()
                        }
                        else if let cell = cell as? PhotoCollectionViewCell
                        {
                            cell.imageView.image = image
                            cell.activityIndicator.stopAnimating()
                        }
                    })
                }
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cellData(indexPath.item, cell: cell)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "WebSegue")
        {
            if let indexPath = collectionView.indexPathsForSelectedItems()?.first
            {
                let photo = photos[indexPath.item]
                let vc = segue.destinationViewController as! WebViewController
                vc.url = NSURL(string: photo.uri)
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
