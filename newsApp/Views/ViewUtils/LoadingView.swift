//
//  LoadingView.swift
//  newsApp
//
//  Created by malek belayeb on 28/12/2021.
//

import Foundation
import UIKit


class LoadingView
{
 
    static let shared: LoadingView = {
            let instance = LoadingView()
            return instance
        }()
    
    lazy var actInd: UIActivityIndicatorView = {

           actInd = UIActivityIndicatorView()

           actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)

            actInd.style = UIActivityIndicatorView.Style.whiteLarge

           actInd.center = CGPoint(x: loadingView.frame.size.width / 2,

                                   y: loadingView.frame.size.height / 2)

           actInd.startAnimating()
           return actInd

           

       }()

       

        lazy var loadingView : UIView = {

           loadingView = UIView()
           loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.backgroundColor = .systemTeal
           loadingView.clipsToBounds = true
           loadingView.layer.cornerRadius = 10
            return loadingView

           

       }()


    func showLoadingView(view:UIView)
    {
        
        loadingView.addSubview(actInd)
        view.addSubview(loadingView)
        loadingView.center = view.center
        
    }
    
    func dismissLoadingView()
    {
        self.loadingView.removeFromSuperview()
    }
    
    
}
