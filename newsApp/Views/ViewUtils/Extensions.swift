//
//  Extensions.swift
//  newsApp
//
//  Created by malek belayeb on 2/1/2022.
//

import UIKit

extension UIImageView
{
    
    func setDownloadedImage(path:String)
    {
            
        WebServiceProvider.shared.downloadImage(url: path, responseImageHandler: {
            image in
            
            self.image = image

        })
        
    }
    
}

extension UIView {
    func applyLayerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        
        layer.frame.size =  CGSize(width: self.frame.width, height: self.frame.height)
        layer.frame.origin = CGPoint(x: 0.0,y: 0.0)
        layer.cornerRadius = 4

        let color0 = UIColor.clear.cgColor
        let color1 = UIColor.black.withAlphaComponent(0.9).cgColor

        layer.colors = [color0,color1]
        self.layer.sublayers = [layer]
    }
}
