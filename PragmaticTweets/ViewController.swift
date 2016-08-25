//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 8/21/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    
    @IBOutlet weak var twitterWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleShowButtonTapped(sender: UIButton) {
        reloadTweets()
    }

    @IBAction func handleSendButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("アンバカ #pragios9")
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            NSLog("Can't Send Tweet")
        }
    }
    
    func reloadTweets() {
        if let url = NSURL (string: "https://twitter.com/liyicky") {
            twitterWebView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    
    
}

