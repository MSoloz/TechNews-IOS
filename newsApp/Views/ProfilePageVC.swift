

import UIKit

class ProfilePageVC: UIViewController {

    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    
    
    @IBOutlet weak var profileNameTextField: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2

        if let user = self.user,let nom = user.nom,let prenom = user.prenom
        {
            
            self.profileNameTextField.text = prenom + " "  + nom
            
            if let img = user.image
            {
                
                let imgPath = Utils.URL_IMAGE_PATH+"USERImg/"+img
                WebServiceProvider.shared.downloadImage(url: imgPath, responseImageHandler: {
                    image in
                
                    self.profileImage.image = image
                    
                })
            }

        }
        
    }
    
    @IBAction func logoutDidClicked(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure do you want to leave ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: {_ in
            
            UserLocalService.shared.clearAll()
            
            let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.viewControllers = [loginVC]

        }))
        
        alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func myNewsTapped(_ sender: Any) {
         
        let myNews = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCreationViewController") as! MyCreationViewController
        
        myNews.isEvent = false
            
        self.navigationController?.pushViewController(myNews, animated: true)
    }
    
    
    
    
    
    @IBAction func myEventsTapped(_ sender: Any) {
    
        let myEvents = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyCreationViewController") as! MyCreationViewController
    
        myEvents.isEvent = true
        
        self.navigationController?.pushViewController(myEvents, animated: true)
    
    }
    
    
    @IBAction func moveToEditProfile(_ sender: Any) {
        
        performSegue(withIdentifier: "segep", sender: sender)
        
    }
    
  

}
