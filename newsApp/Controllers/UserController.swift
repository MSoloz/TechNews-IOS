

import Foundation
import UIKit

protocol LoginResponseNotifier
{
    
    func showLoading()
    func userSuccessfullyLoggedIn(user: User)
    func wrongCredential()
    func serverNotResponding()
    
}

protocol SignUpResponseNotifier
{
    
    func showLoading()
    func userSuccessfullyCreated()
    func userAlreadyExist()
    func serverNotResponding()
    
}

protocol UpdateProfileResponseNotifier
{
    
    func showLoading()
    func userSuccessfullyUpdated()
    func serverNotResponding()
    
}

protocol getAllUsersResponseNotifier
{
    
    func showLoading()
    func allUsersFound(users:[User])
    func serverNotResponding()
    
}


class UserController {
    
    var loginNotifier:LoginResponseNotifier!
    var signUpNotifier:SignUpResponseNotifier!
    var updateProfileNotifier:UpdateProfileResponseNotifier!
    var getAllUsersNotifier:getAllUsersResponseNotifier!

    static let shared: UserController = {
            let instance = UserController()
            return instance
    }()

    func loginUser(email:String,password:String)
    {
        self.loginNotifier.showLoading()
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/login", method: .post, params:  ["email":email,"password":password], responseHandler: {
            (status, body:User?) in
                       
                if status == 200
                {
                    if let user = body
                    {
                        
                        UserLocalService.shared.addUser(user: user)
                        self.loginNotifier.userSuccessfullyLoggedIn(user: user)
                        
                    }else{
                        
                        self.loginNotifier.serverNotResponding()
                    }
                }else if status == 402
                {
                    
                    self.loginNotifier.wrongCredential()
                    
                }else{
                    
                    self.loginNotifier.serverNotResponding()
               
                }
            
        })
        
    }
    
    
    
    func updateUser(user:User,image:UIImage)
    {
        self.updateProfileNotifier.showLoading()
        let params = ["id":user._id!,"prenom":user.prenom!,"nom":user.nom!,"image":image] as [String : Any]
        
        WebServiceProvider.shared.callWebServiceWithFormData(URL: Utils.URL + "/UpdateUser", method: .post, params:  params, responseHandler: {
            
            (status, body:VoidWSResponse?) in
           
             if status == 201
             {
                 self.updateProfileNotifier.userSuccessfullyUpdated()

             }else{
                 
                 self.updateProfileNotifier.serverNotResponding()
            
             }
 
            
        })
        
        
    
    }
    
    func signUpUser(user:User,password:String,image:UIImage)
    {
        self.signUpNotifier.showLoading()
        
        let params = ["prenom":user.prenom!,"nom":user.nom!,"email":user.email!,"password":password,"image":image] as [String : Any]
        
        WebServiceProvider.shared.callWebServiceWithFormData(URL: Utils.URL + "/SignUp", method: .post, params:  params, responseHandler: {
            
            (status, body:VoidWSResponse?) in
           
             if status == 201
             {
                 self.signUpNotifier.userSuccessfullyCreated()

             }else if status == 402
             {
                 
                 self.signUpNotifier.userAlreadyExist()
                 
             }else{
                 
                 self.signUpNotifier.serverNotResponding()
            
             }
 
            
        })
        
        
        
    }
    
    
    func getAllUser()
    {
        self.getAllUsersNotifier.showLoading()
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/users", method: .get, params:  [:], responseHandler: {
            (status, body:[User]?) in
                       
                if status == 200
                {
                    if let user = body
                    {
                        
                        self.getAllUsersNotifier.allUsersFound(users: user)
                        
                    }else{
                        
                        self.getAllUsersNotifier.serverNotResponding()
                    }
                }else{
                    
                    self.getAllUsersNotifier.serverNotResponding()
               
                }
            
        })
        
    }
    
}
