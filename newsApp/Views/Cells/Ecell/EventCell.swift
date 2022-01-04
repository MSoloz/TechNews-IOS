//
//  EventCell.swift
//  TechNewsApp
//
//  Created by Apple Esprit on 11/11/2021.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var mView: UIView!

    

    
    @IBOutlet weak var mImage: UIImageView!
    
    @IBOutlet weak var mLabel1: UILabel!
    
    
    @IBOutlet weak var mLabel2: UILabel!
    
    
    @IBOutlet weak var mLablel2: UILabel!
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var containerInfo: UIView!
    @IBOutlet weak var backgroundGradient: UIView!
    @IBOutlet weak var participationButton: UIButton!
    @IBOutlet weak var interestButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mImage.layer.cornerRadius = 4
        self.containerInfo.layer.cornerRadius = 4
        self.backgroundGradient.layer.cornerRadius = 4
        self.mainContainer.layer.cornerRadius = 4
        self.mImage.image = nil

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
