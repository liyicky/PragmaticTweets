//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 8/21/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit
import Social

class ViewController: UITableViewController {
    
    @IBOutlet weak var twitterWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section: \(section)"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.textLabel?.text = "Row: \(indexPath.row)"
        return cell
    }
    
    func reloadTweets() {
        
    }
}

