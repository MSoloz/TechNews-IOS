

import UIKit

class CommentsNewsViewController: UIViewController,UITextFieldDelegate,AddCommentNewsResponseNotifier,CommentByNewsResponseNotifier,UITableViewDelegate,UITableViewDataSource {
    
    
    var comments:[Comment] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.commentsTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        
        cell.messageTextView.text = self.comments[indexPath.row].comment
        cell.usernameLabel.text = self.comments[indexPath.row].user!.prenom! + " " + self.comments[indexPath.row].user!.nom!
        
        let imgUserPath = Utils.URL_IMAGE_PATH+"USERImg/" + self.comments[indexPath.row].user!.image!

        cell.imageProfileUser.setDownloadedImage(path: imgUserPath)
        return cell
        
    }
    
    

    func showLoadingFetchComment() {
        LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func allCommentsDidFetched(comments:[Comment]) {
        
        LoadingView.shared.dismissLoadingView()

        self.comments = comments
        self.commentsTableView.reloadData()
        
    }
    
    func serverNotRespondingFetchComment() {
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    
    var news:News?
    
    func showLoading() {
        LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func commentNewsDidCreated() {
        LoadingView.shared.dismissLoadingView()
        NewsController.shared.getCommentsByNews(idnews: self.news!._id!)

    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
        
    }
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true

    }
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NewsController.shared.AddCommentNewsResponseNotifier = self
        NewsController.shared.commentByNewsResponseNotifier = self
        
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
    
        self.commentsTableView.register(UINib.init(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        
        NewsController.shared.getCommentsByNews(idnews: self.news!._id!)

        
    }
    

    @IBAction func commentTapped(_ sender: Any) {
        
        if let news = news,let user = user {
            if let commentsText = self.commentTextField.text
            {
                if commentsText.isEmpty == false{
                    
                    NewsController.shared.addComment(idnews: news._id!, comment: commentsText, iduser: user._id!)
                    
                }
            }
            

        }
        
    }
    
}
