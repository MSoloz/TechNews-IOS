//
//  MyEventTableViewCell.swift
//  newsApp
//
//  Created by malek belayeb on 4/1/2022.
//

import UIKit

class MyEventTableViewCell: UITableViewCell {

    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var containerInfo: UIView!
    @IBOutlet weak var backgroundGradient: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageEvent.layer.cornerRadius = 4
        self.containerInfo.layer.cornerRadius = 4
        self.backgroundGradient.layer.cornerRadius = 4
        self.mainContainer.layer.cornerRadius = 4
        self.imageEvent.image = nil


    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundGradient.applyLayerGradient()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
