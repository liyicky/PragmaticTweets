//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 8/21/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit
import Social
import Accounts

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
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let twitterParams = [ "count" : "100"]
        let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                                requestMethod: .GET,
                                URL: twitterAPIURL,
                                parameters: twitterParams)

        
        // Auth and get Accounts from iOS, get Response from Twitter **************************************************************
        accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: { (granted: Bool, error: NSError!) -> Void in guard granted else {
                NSLog("Account Access Denied")
                return
            }
            NSLog("Account Access Granted")
            
            let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
            guard twitterAccounts.count > 0 else {
                NSLog("No Twitter Accounts Configured")
                return
            }
            
            request.account = twitterAccounts.first as! ACAccount
            request.performRequestWithHandler( { (data: NSData!, urlReponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                self.handleTwitterData(data, urlResponse: urlReponse, error: error)
            })
        })
        
        
        
    }
    
    private func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() received no data!")
            return
        }
        NSLog("handleTwitterData(), \(data.length) bytes")
        
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            print("\(jsonObject)")

        } catch let error as NSError {
            NSLog("Json Error: \(error)")
        }
        
    }
}

