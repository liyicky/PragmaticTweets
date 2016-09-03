//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 8/21/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit
import Social

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

var parsedTweets: [ParsedTweet] = [
    ParsedTweet(tweetText : "iOS 9 SDK Development now in print. " +
        "Swift programming FTW!",
        userName: "@pragprog",
        createdAt: "2015-09-09 15:44:30 EDT", userAvatarURL: defaultAvatarURL),
    ParsedTweet(tweetText : "But was that really such a good idea?", userName: "@redqueencoder",
        createdAt: "2014-12-04 22:15:55 CST",
        userAvatarURL: defaultAvatarURL),
    ParsedTweet(tweetText : "Struct all the things!", userName: "@invalidname",
        createdAt: "2015-07-31 05:39:39 EDT", userAvatarURL: defaultAvatarURL)
]

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        refreshControl = refresher
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as! ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        
        if let url = parsedTweet.userAvatarURL, imageData = NSData(contentsOfURL: url) {
            cell.avatarImageView.image = UIImage(data: imageData)
        }
        
        cell.usernameLabel.text = parsedTweet.userName
        cell.tweetLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        
        return cell
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        parsedTweets.append(ParsedTweet(tweetText: "New Row",
                            userName: "@refresh",
                            createdAt: NSDate().description,
                            userAvatarURL: defaultAvatarURL))
        reloadTweets()
        refreshControl?.endRefreshing()
    }
    
    func reloadTweets() {
        tableView.reloadData()
    }
}

