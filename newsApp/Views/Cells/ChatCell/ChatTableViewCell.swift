//
//  ChatTableViewCell.swift
//  newsApp
//
//  Created by malek belayeb on 3/1/2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfileUser: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageProfileUser.layer.cornerRadius = self.imageProfileUser.frame.height/2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
