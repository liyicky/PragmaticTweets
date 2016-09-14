//
//  TwitterAPIRequestUtilities.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 9/14/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import Social
import Accounts

func sentTwitterRequest(requestURL: NSURL, params: [String: String], completion: SLRequestHandler) {
    let accountStore = ACAccountStore()
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    
    accountStore.requestAccessToAccountsWithType(twitterAccountType, options: nil, completion: {
        (granted: Bool, error: NSError!) -> Void in guard granted else {
            NSLog("Account Access not Granted")
            return
        }
        
        let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
        guard twitterAccounts.count > 0 else {
            NSLog("No Twitter Accounts Configured")
            return
        }
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: requestURL, parameters: params)
        request.account = twitterAccounts.first as! ACAccount
        request.performRequestWithHandler(completion)
        
    })
}

