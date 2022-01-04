//
//  AlertResponseView.swift
//  newsApp
//
//  Created by malek belayeb on 29/12/2021.
//

import Foundation
import UIKit


class AlertResponseView
{
    static let shared: AlertResponseView = {
            let instance = AlertResponseView()
            return instance
        }()
    
    func showAlert(message:String,viewController:UIViewController,handler: ( () -> ())?)
    {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        
            if let handler = handler {
            
                handler()
                
            }
            
        }))
        
        viewController.present(alert, animated: true, completion: nil)
        
    }
    
}
