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
        
        cellData(indexPath.row, cell: cell)

        return cell
    }
    
    func cellData(index: Int, cell: UIView)
    {
        if let photo = photos?[index]
        {
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
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let photos = self.photos
        {
            return photos.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cellData(indexPath.item, cell: cell)
        return cell
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
