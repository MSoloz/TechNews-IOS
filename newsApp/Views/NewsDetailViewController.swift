

import UIKit

class NewsDetailViewController: UIViewController,DeleteNewsResponseNotifier,LikeDislikeNewsResponseNotifier {
    
    
    
    func showLoadingNewsLikeDislike() {
        //	LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func newsLiked() {
        //LoadingView.shared.dismissLoadingView()
        self.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)

    }
    
    func newsDisLiked() {
        //LoadingView.shared.dismissLoadingView()
        self.likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)

    }
    
    func serverNotRespondingNewsLikeDislike() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
        
    }
    
    func showLoading() {
        LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func newsDeletedSuccessfully() {
        
        LoadingView.shared.dismissLoadingView()
        self.navigationController?.popViewController(animated: true)

    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    
    }
    

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var viewCommentsBtn: UIButton!
    @IBOutlet weak var deleteNewsBtn: UIButton!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var NewsDescription: UITextView!
    var news:News?
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NewsController.shared.deleteNewsNotifier = self
        NewsController.shared.likeDislikeNewsResponseNotifier = self
        
        if let news = news {
            
            self.newsImageView.layer.cornerRadius = 4
            self.viewCommentsBtn.setTitle("View comments ("+news.comments!.count.description+") ", for: .normal)
            self.newsTitleLabel.text = news.title
            self.NewsDescription.text = news.desc
            let imgNewsPath = Utils.URL_IMAGE_PATH+"NewsImg/"+news.image!
            self.newsImageView.setDownloadedImage(path: imgNewsPath)
            
            if self.news!.likes!.contains(where: { $0.user?._id! == self.user!._id! })
            {
                self.likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)

            }else{
                
                self.likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)

            }
            
            if news.creator?._id == self.user?._id
            {
                self.deleteNewsBtn.isHidden = false
            }else{
                
                self.deleteNewsBtn.isHidden = true

            }
        }
        
    }
    
    
    @IBAction func deleteNewsTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Deleting...", message: "Are you sure do you want to delete ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            
            if let news = self.news, let id = news._id {
                
                NewsController.shared.deleteNews(idnews: id)
                
            }

        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
     
    }
    
    @IBAction func gobackToPrevious(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func viewCommentsTapped(_ sender: Any) {
        
        let comments = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsNewsViewController") as! CommentsNewsViewController
        comments.news = self.news
        self.present(comments, animated: true, completion: nil)
        
    }
    
    
    @IBAction func likeTapped(_ sender: Any) {
        
        NewsController.shared.likeDislikeNews(iduser: user!._id!, idnews: news!._id!)

    }
    
    
}
