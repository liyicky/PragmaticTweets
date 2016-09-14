//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 9/14/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweetID : String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    
    
    
    func reloadTweetDetails() {
        
    }
    
}
