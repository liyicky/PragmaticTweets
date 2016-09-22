//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 9/14/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userUsernameLabel: UILabel!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    var tweetID : String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    override func viewDidLoad() {
        reloadTweetDetails()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userDetailVC = segue.destinationViewController as? UserDetailViewController
            where segue.identifier == "showUserDetailSegue" {
            userDetailVC.screenName = userUsernameLabel.text
        }
    }
    
    @IBAction func unwindToTweetDetailVC(withUnwindSegue unwindSegue: UIStoryboardSegue) {
        NSLog("Unwind to TweetDetail")
    }
    
    func reloadTweetDetails() {
        guard let tweetID = tweetID else {
            return
        }
        
        if let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/show.json") {
            let twitterParams = ["id": tweetID]
            sendTwitterRequest(twitterAPIURL, params: twitterParams, completion: { (data, urlResponse, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
            })
        }
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            return
        }
        
        NSLog("Handle Twitter Data: \(data.length)")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let tweetDict = jsonObject as? [String: AnyObject] else {
                NSLog("handleTwitterData() didn't get a dict")
                return
            }
            
            self.tweetTextLabel.text = tweetDict["text"] as? String
            
            if let userDict = tweetDict["user"] as? [String : AnyObject] {
                self.userRealNameLabel.text = (userDict["name"] as! String)
                self.userUsernameLabel.text = (userDict["screen_name"] as! String)
                self.userImageButton.setTitle(nil, forState: .Normal)
                
                if let userImageURL = NSURL(string: userDict["profile_image_url_https"] as! String),
                    userImageData = NSData(contentsOfURL: userImageURL) {
                    self.userImageButton.setImage(UIImage(data: userImageData), forState: .Normal)
                }
                
                if let entities = tweetDict["entities"] as? [String : AnyObject],
                media = entities["media"] as? [[String : AnyObject]],
                mediaString = media[0]["media_url_https"] as? String,
                mediaURL = NSURL(string: mediaString),
                mediaData = NSData(contentsOfURL: mediaURL) {
                    tweetImageView.image = UIImage(data: mediaData)
                }
            }
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
