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
    @IBOutlet weak var doneButton: UIButton!
    
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
        
        
        
    }
    
    
    
    
}

