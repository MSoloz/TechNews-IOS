

import UIKit
import SendBirdSDK

struct UserChannel
{
    var channelUrl :String?
    var img:String?
    var name:String?
}

class AllUserChatViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,getAllUsersResponseNotifier,GetChatResponseNotifier {
    
    
    func showLoadingChat() {
        LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func chatDidFound(chat: Chat,user:User,other:User) {
        LoadingView.shared.dismissLoadingView()

        let singleChat = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SingleChatViewController") as! SingleChatViewController
        
        singleChat.channelUrl = chat.channelUrl
        singleChat.otherUser = other
        singleChat.me = user
        
        self.present(singleChat, animated: true, completion: nil)
        
    }
    
    func serverNotRespondingChat() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self, handler: nil)
    
    }
    
    func showLoading() {
        LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func allUsersFound(users: [User]) {
        
        LoadingView.shared.dismissLoadingView()
        self.users = users
        self.allUsersTableView.reloadData()
        
    }
    
    func serverNotResponding() {
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    
    
    @IBOutlet weak var allUsersTableView: UITableView!
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.allUsersTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
    
        let imgUserPath = Utils.URL_IMAGE_PATH+"USERImg/" + self.users[indexPath.row].image!
        
        cell.userImage.setDownloadedImage(path: imgUserPath)
        cell.usernameLabel.text = self.users[indexPath.row].prenom! + " " + self.users[indexPath.row].nom!
        
        return cell
    }
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allUsersTableView.delegate = self
        allUsersTableView.dataSource = self
        UserController.shared.getAllUsersNotifier = self
        ChatController.shared.getChatResponseNotifier = self
        allUsersTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        UserController.shared.getAllUser()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        ChatController.shared.getChat(user: self.user!, other: self.users[indexPath.row])

    }
    
    
    @IBAction func goBackToPrevious(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true )
        
    }
    

}
