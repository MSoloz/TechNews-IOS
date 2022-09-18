import UIKit
import SendBirdSDK


class HomePageVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NewsResponseNotifier {
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    func showLoading() {

        LoadingView.shared.showLoadingView(view: self.view)

    }
    
    func allNewsDidFetched(news: [News]) {
        LoadingView.shared.dismissLoadingView()
        self.news = news
        self.tableViewH.reloadData()
    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
            
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
            NewsController.shared.getNews()
            

    }

    var news : [News] = []
    
    @IBOutlet weak var tableViewH: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsController.shared.newsNotifier = self
        
        let nib = UINib(nibName: "NCell1", bundle: nil)
        
        self.tableViewH.delegate = self
        self.tableViewH.dataSource = self
        self.tableViewH.register(nib, forCellReuseIdentifier: "NCell1")
        
        
        let flatBtn = FloatingButton.createFloatingButton(view: self.view)
        view.addSubview(flatBtn)
        flatBtn.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
    }
    
    @objc private func didTapButton(){
        
        let addNews = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewsPageVC")
        self.navigationController?.pushViewController(addNews, animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
       return  self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "NCell1") as! NCell1

        cell.NewsNameLabel.text = news[indexPath.row].title
        cell.DescNameLabel.text = news[indexPath.row].desc
        cell.UserNameLabel.text = news[indexPath.row].creator!.prenom! + " " + news[indexPath.row].creator!.nom!
        
        cell.commentButton.setTitle(" " + news[indexPath.row].comments!.count.description, for: .normal)
        cell.likeButton.setTitle(" " + news[indexPath.row].likes!.count.description, for: .normal)
        
        let imgNewsPath = Utils.URL_IMAGE_PATH+"NewsImg/"+news[indexPath.row].image!
        cell.NewsImage.setDownloadedImage(path: imgNewsPath)

        let imgUserPath = Utils.URL_IMAGE_PATH+"UserImg/"+news[indexPath.row].creator!.image!
        cell.UserImage.setDownloadedImage(path: imgUserPath)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let newsDetailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        
        newsDetailVC.news = self.news[indexPath.row]
        newsDetailVC.modalTransitionStyle = .coverVertical
        newsDetailVC.modalPresentationStyle = .automatic
        
        self.navigationController?.pushViewController(newsDetailVC, animated: true)
        
        
    }
    

    
}
    
    

