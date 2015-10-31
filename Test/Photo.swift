//
//  Photo.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 10/31/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import Foundation

class Photo: NSObject
{
    var name: String?
    var uri = ""
    
    convenience init(name: String? = "Image", uri: String)
    {
        self.init()
        
        self.name = name
        self.uri = uri
    }
    
    class func getPhotos(name: String = "images") -> [Photo]?
    {
        let path = NSBundle.mainBundle().URLForResource(name, withExtension: "plist")
        print(path)
        
        if let url = path
        {
            if let database = NSArray(contentsOfURL: url) as? [String]
            {
                let photos: [Photo] = database.map({
                    if let url = NSURL(string: $0)
                    {
                        let photo = Photo(name: url.lastPathComponent, uri: $0)
                        return photo
                    }
                    else
                    {
                        let photo = Photo(uri: $0)
                        return photo
                    }
                })
                
                return photos
            }
        }
        
        return nil
    }
    
    class func downloadPhoto(photo: Photo, path: String) -> UIImage?
    {
        if let url = NSURL(string: photo.uri)
        {
            if let data = NSData(contentsOfURL: url)
            {
                data.writeToFile(path, atomically: true)
                return UIImage(data: data)
            }
        }
        
        return nil
    }
    
    class func cachePhoto(photo: Photo) -> UIImage?
    {
        if let url = NSURL(string: photo.uri)
        {
            if let caches = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            {
                let path = "\(caches)/\(url.lastPathComponent)"
                
                if (NSFileManager.defaultManager().fileExistsAtPath(path))
                {
                    let image = UIImage(contentsOfFile: path)
                    return image
                }
                else
                {
                    return downloadPhoto(photo, path: path)
                }
            }
        }
        
        return nil
    }
}