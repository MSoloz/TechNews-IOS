

import UIKit
import SendBirdSDK


class ChatViewController: UIViewController {

    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let floattingButton = FloatingButton.createFloatingButton(view: self.view)
        view.addSubview(floattingButton)
        floattingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
       
    if let u = user,let id = u._id
        {
            
            SBDMain.connect(withUserId: id) { user, error in
                guard let user = user, error == nil else {
                        return
                }
                
                SBDMain.updateCurrentUserInfo(withNickname: u.prenom! + " " + u.nom!, profileImageFilePath: u.image, progressHandler: nil, completionHandler: nil)
        }
    
    }
        
        
    }
    
    
    @objc private func didTapButton(){
        
        let AllUserChatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllUserChatViewController")
        //self.present(AllUserChatVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(AllUserChatVC, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
