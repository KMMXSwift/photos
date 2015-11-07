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
    var imageURI = ""
    var uri = ""
    
    convenience init(name: String? = "Image", imageURI: String, uri: String)
    {
        self.init()
        
        self.name = name
        self.imageURI = imageURI
        self.uri = uri
    }
    
    class func getPhotos(name: String = "wikipedia") -> [Photo]?
    {
        let path = NSBundle.mainBundle().URLForResource(name, withExtension: "plist")
        
        if let url = path
        {
            if let database = NSArray(contentsOfURL: url) as? [[String : String]]
            {
                let photos: [Photo] = database.map({
                    
                    if let imageURI = $0["image"]
                    {
                        if let uri = $0["uri"]
                        {
                            if let url = NSURL(string: imageURI)
                            {
                                let photo = Photo(name: url.lastPathComponent, imageURI: imageURI, uri: uri)
                                return photo
                            }
                            else
                            {
                                let photo = Photo(imageURI: imageURI, uri: uri)
                                return photo
                            }
                        }
                    }
                    
                    return Photo()
                })
                
                return photos
            }
        }
        
        return nil
    }
    
    class func downloadPhoto(photo: Photo, path: String) -> UIImage?
    {
        if let url = NSURL(string: photo.imageURI)
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
        if let url = NSURL(string: photo.imageURI)
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