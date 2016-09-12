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



class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = []
    
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
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), {
            if let url = parsedTweet.userAvatarURL,
                imageData = NSData(contentsOfURL: url)
                where cell.usernameLabel.text == parsedTweet.userName {
                dispatch_async(dispatch_get_main_queue(), {
                    cell.avatarImageView.image = UIImage(data: imageData)
                })
            }
        })
        
        
        cell.usernameLabel.text = parsedTweet.userName
        cell.tweetLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        
        return cell
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
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
            guard let jsonArray = jsonObject as? [[String : AnyObject]] else {
                NSLog ("handleTwitterData() didn't get an array")
                return
            }
            createParsedTweets(jsonArray)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
        } catch let error as NSError {
            NSLog("Json Error: \(error)")
        }
        
    }
    
    private func createParsedTweets(tweetArray: NSArray) {
        for tweetDict in tweetArray {
            var parsedTweet = ParsedTweet()
            parsedTweet.tweetText = tweetDict["text"] as? String
            parsedTweet.createdAt = tweetDict["created_at"] as? String
            if let userDict = tweetDict["user"] as? [String : AnyObject] {
                parsedTweet.userName = userDict["name"] as? String
                if let avatarURLString = userDict["profile_image_url_https"] as? String {
                    parsedTweet.userAvatarURL = NSURL(string: avatarURLString)
                }
            }
            parsedTweets.append(parsedTweet)
        }
    }
}

