//
//  ParsedTweetCell.swift
//  PragmaticTweets
//
//  Created by Jason Cheladyn on 9/1/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import UIKit



class ParsedTweetCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
