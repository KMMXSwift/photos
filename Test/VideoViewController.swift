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
import MessageUI

class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var songsTableView: UITableView!
    
    @IBOutlet weak var playButton: UIButton!
    let musicPlayer = MPMusicPlayerController()
    
    var songs: [MPMediaItem] = []
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            if let url = NSBundle.mainBundle().URLForResource("music", withExtension: "m4a")
            {
                self.audioPlayer = try AVAudioPlayer(contentsOfURL: url)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.play()
            }
        }
            
        catch
        {
            print("AVAudioSession setup failed")
        }
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
    
    @IBAction func shareVideo(sender: UIBarButtonItem)
    {
        let user = (body: "Hello! This is a test.", subject: "KMMX", recipients: ["me@richiereyes.com"])
        
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = self
        vc.setMessageBody(user.body, isHTML: false)
        vc.setSubject(user.subject)
        vc.setToRecipients(user.recipients)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func powers(tuple: (a: Float, b: Float, c: Float)) -> (square: Float, cubed: Float, fourth: Float)
    {
        let square = pow(tuple.a, 2.0)
        let cubed = pow(tuple.b, 3.0)
        let fourth = pow(tuple.c, 4.0)
        
        return (square, cubed, fourth)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        switch (result)
        {
        case MFMailComposeResultCancelled:
            print("Cancelled")
        case MFMailComposeResultFailed:
            print("Failed")
        case MFMailComposeResultSaved:
            print("Saved")
        case MFMailComposeResultSent:
            print("Sent")
        default:
            print("Default")
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
