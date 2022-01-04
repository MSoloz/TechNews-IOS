//
//  UserLocalService.swift
//  newsApp
//
//  Created by malek belayeb on 30/12/2021.
//

import Foundation
import CoreData
import UIKit




class UserLocalService
{
    
    static let shared: UserLocalService = {
            let instance = UserLocalService()
            return instance
    }()

    var managedContext: NSManagedObjectContext{
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       return appDelegate.persistentContainer.viewContext
    }

    func addUser(user:User)
    {
            
            let entity =
                    NSEntityDescription.entity(forEntityName: "LocalUser",
                                               in: managedContext)!
                
            let userLocalEntity = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
    
        userLocalEntity.setValue(user.nom, forKeyPath: "nom")
        userLocalEntity.setValue(user.prenom, forKeyPath: "prenom")
        
            userLocalEntity.setValue(user.email, forKeyPath: "email")
            userLocalEntity.setValue(user.image, forKeyPath: "image")
            userLocalEntity.setValue(user._id, forKeyPath: "id")
      
                do {

                    try managedContext.save()

                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
        
    }
    
    func getUser() -> [User]
    {
        
        var users : [User] = []
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalUser")
        
        //fetchRequest.fetchLimit = 1
        //fetchRequest.predicate = NSPredicate(format: "nom = %@", "malek")
        //fetchRequest.predicate = NSPredicate(format: "id == %@", "3335")
        //fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
                
            for user in result
            {
                
                let u = User()
                u.email = user.value(forKey: "email") as? String
                u.image = user.value(forKey: "image") as? String
                u._id = user.value(forKey: "id") as? String
                u.nom = user.value(forKey: "nom") as? String
                u.prenom = user.value(forKey: "prenom") as? String
                users.append(u)
                
            }
            
        }catch{
            
            print(error)
            
        }
        return users
    }
    
    func clearAll()
    {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocalUser")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            
            try managedContext.execute(batchDeleteRequest)

        } catch let err as NSError {
            
            print("Could not delete. \(err)")

        }
        
    }
    
}


