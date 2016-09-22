//
//  UserDetailsViewController.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 9/20/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var screenName: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        guard let screenName = screenName else {
            return
        }
        
        let twitterParams = ["screen_name" : screenName]
        if let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/users/show.json") {
            sendTwitterRequest(twitterAPIURL, params: twitterParams, completion: {
                (data, urlResponse, error) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
            })
        }
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() received no data")
            return
        }
        
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let tweetDict = jsonObject as? [String : AnyObject] else {
                NSLog("handleTwitterData() doesn't contain a dictionary")
                return
            }
            usernameLabel.text = tweetDict["name"] as! String
            screenNameLabel.text = tweetDict["screen_name"] as! String
            locationLabel.text = tweetDict["location"] as! String
            descriptionLabel.text = tweetDict["description"] as! String
            
            if let userImageURL = NSURL(string: (tweetDict["profile_image_url_https"] as! String)),
            userImageData = NSData(contentsOfURL: userImageURL) {
                userImageView.image = UIImage(data: userImageData)
            }
        } catch let error as NSError {
            NSLog("JSON Error: \(error)")
        }
        
    }
    
    
    
    
}

