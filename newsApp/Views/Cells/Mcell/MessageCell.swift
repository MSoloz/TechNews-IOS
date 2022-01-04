//
//  MessageCell.swift
//  TechNewsApp
//
//  Created by iMac Esprit on 10/11/2021.
//

import UIKit

class MessageCell: UITableViewCell {
    

    @IBOutlet weak var mImage: UIImageView!
    
    @IBOutlet weak var mView: UIView!
    
    @IBOutlet weak var mLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
