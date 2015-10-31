//
//  PhotoTableViewCell.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 10/31/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell
{
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}