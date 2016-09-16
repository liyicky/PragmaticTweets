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

var parsedTweets: [ParsedTweet] = []

class RootViewController: UITableViewController {
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let row = tableView?.indexPathForSelectedRow?.row,
            tweetDetailsVC = segue.destinationViewController as? TweetDetailViewController {
                let parsedTweet = parsedTweets[row]
                tweetDetailsVC.tweetID = parsedTweet.tweetId
            }
        }
    }
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        reloadTweets()
        refreshControl?.endRefreshing()
    }
    
    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("Type Tweet Here")
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            NSLog("Can't send Tweet")
        }
        
    }
    
    func reloadTweets() {
                let twitterParams = [ "count" : "100"]
        guard let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json") else {
            return
        }
        
        // Auth and get Accounts from iOS, get Response from Twitter **************************************************************
        sendTwitterRequest(twitterAPIURL, params: twitterParams, completion: {
            (data, urlResponse, error) -> Void in
            self.handleTwitterData(data, urlResponse: urlResponse, error: error)
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
        parsedTweets = []
        for tweetDict in tweetArray {
            var parsedTweet = ParsedTweet()
            parsedTweet.tweetText = tweetDict["text"] as? String
            parsedTweet.createdAt = tweetDict["created_at"] as? String
            parsedTweet.tweetId = tweetDict["id_str"] as? String
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

