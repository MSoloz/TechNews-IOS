//
//  MyNewsTableViewCell.swift
//  newsApp
//
//  Created by malek belayeb on 4/1/2022.
//

import UIKit

class MyNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var gradientBackground: UIView!
    @IBOutlet weak var NewsNameLabel: UILabel!
    @IBOutlet weak var DescNameLabel: UILabel!
    @IBOutlet weak var NewsImage: UIImageView!
    @IBOutlet weak var containerInfo: UIView!
    
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.NewsImage.layer.cornerRadius = 4
        self.containerInfo.layer.cornerRadius = 4
        
        NewsImage.image = nil

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBackground.applyLayerGradient()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
