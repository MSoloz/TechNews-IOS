//
//  FloatingButton.swift
//  newsApp
//
//  Created by malek belayeb on 30/12/2021.
//

import UIKit


class FloatingButton {
    
    
    static func createFloatingButton(view:UIView) -> UIButton
    {
        let button = UIButton(frame: CGRect(x:0,y:0,width: 68,height: 68))
        
        button.layer.cornerRadius = 30
        
        button.backgroundColor = .systemTeal
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32,weight: .medium))
        
        button.setImage(image, for: .normal)
        
        button.tintColor = .white
        
        button.setTitleColor(.white, for: .normal)
        
        button.layer.shadowRadius = 10
        
        button.layer.shadowOpacity = 0.4
        
        button.frame = CGRect(x:view.frame.size.width - 70,
                                      
                                       y:view.frame.size.height - 180,
                                       
                                       width:60,
                                       
                                       height: 60)
        
        return button
    }
    
    
}
