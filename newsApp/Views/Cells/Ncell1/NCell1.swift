//
//  NCell1.swift
//  TechNewsApp
//
//  Created by Apple Esprit on 3/12/2021.
//

import UIKit

class NCell1: UITableViewCell {
    
    
    @IBOutlet weak var UserImage: UIImageView!
    
    @IBOutlet weak var UserNameLabel: UILabel!
    
    @IBOutlet weak var gradientBackground: UIView!
    
    @IBOutlet weak var NewsNameLabel: UILabel!
    
    @IBOutlet weak var DescNameLabel: UILabel!
    
    @IBOutlet weak var NewsImage: UIImageView!
    
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var containerInfo: UIView!
    
    let colorTop = UIColor.clear
    
    let colorBottom = UIColor.black

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.NewsImage.layer.cornerRadius = 4
        self.containerInfo.layer.cornerRadius = 4
        UserImage.image = nil
        NewsImage.image = nil
        UserImage.layer.cornerRadius = UserImage.frame.height / 2

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientBackground.applyLayerGradient()

    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
