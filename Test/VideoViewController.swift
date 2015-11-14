//
//  VideoViewController.swift
//  Test
//
//  Created by Ricardo Michel Reyes Martínez on 11/14/15.
//  Copyright © 2015 KMMX. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var songsTableView: UITableView!
    
    @IBOutlet weak var playButton: UIButton!
    let musicPlayer = MPMusicPlayerController()
    
    var songs: [MPMediaItem] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "VideoSegue")
        {
            if let vc = segue.destinationViewController as? AVPlayerViewController
            {
                if let url = NSURL(string: "https://richiereyes.com/kmmx/video.mp4")
                {
                    vc.player = AVPlayer(URL: url)
                }
            }
        }
    }

    @IBAction func play(sender: UIButton)
    {
        switch (musicPlayer.playbackState)
        {
        case .Playing:
            musicPlayer.pause()
            playButton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        
        default:
            let query = MPMediaQuery.songsQuery()
            musicPlayer.setQueueWithQuery(query)
            
            if let items = query.items
            {
                songs = items
                songsTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongCell")!
        
        let item = songs[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songs.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let item = songs[indexPath.row]
        
        musicPlayer.nowPlayingItem = item
        musicPlayer.play()
        
        playButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
    }
    
    @IBAction func next(sender: UIButton)
    {
        musicPlayer.skipToNextItem()
    }
    
    @IBAction func previous(sender: UIButton)
    {
        musicPlayer.skipToPreviousItem()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
