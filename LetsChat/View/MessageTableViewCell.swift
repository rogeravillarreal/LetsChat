//
//  MessageTableViewCell.swift
//  LetsChat
//
//  Created by Roger Villarreal on 2/7/18.
//  Copyright © 2018 Roger Alexander. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var senderUserName: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
