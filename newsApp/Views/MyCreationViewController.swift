
import UIKit

class MyCreationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewsByUserResponseNotifier,EventByUserResponseNotifier {
    
    func showLoadingNews() {
            
        LoadingView.shared.showLoadingView(view: self.view)
    
    }
    
    func newsByUserDidFetched(news: [News]) {
        LoadingView.shared.dismissLoadingView()

        self.myNews = news
        self.myCreationTableView.reloadData()
    }
    
    func serverNotRespondingNews() {
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    
    func showLoadingEvent() {
        LoadingView.shared.showLoadingView(view: self.view)
        
    }
    
    func EventByUserDidFetched(events: [Event]) {
        LoadingView.shared.dismissLoadingView()
        self.myEvents = events
        self.myCreationTableView.reloadData()
    }
    
    func serverNotRespondingEvent() {
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let isEvent = isEvent {
            if isEvent
            {
                
                return myEvents.count
            }else{
                
                return myNews.count
            }
            
        }else{
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let isEvent = isEvent {

            if isEvent
            {
                let cell = myCreationTableView.dequeueReusableCell(withIdentifier: "MyEventTableViewCell", for: indexPath) as! MyEventTableViewCell
                cell.titleLabel.text = myEvents[indexPath.row].name
                cell.descriptionLabel.text = myEvents[indexPath.row].event_time
                cell.adressLabel.text = myEvents[indexPath.row].adress
                    
                let imgEventPath = Utils.URL_IMAGE_PATH+"EventImg/"+myEvents[indexPath.row].image!
                cell.imageEvent.setDownloadedImage(path: imgEventPath)
                
                return cell
                
            }else{
                let cell = myCreationTableView.dequeueReusableCell(withIdentifier: "MyNewsTableViewCell", for: indexPath) as! MyNewsTableViewCell
                    
                cell.NewsNameLabel.text = myNews[indexPath.row].title
                cell.DescNameLabel.text = myNews[indexPath.row].desc
                cell.commentsButton.setTitle(" " + myNews[indexPath.row].comments!.count.description, for: .normal)
                cell.likesButton.setTitle(" " + myNews[indexPath.row].likes!.count.description, for: .normal)
               
                let imgNewsPath = Utils.URL_IMAGE_PATH+"NewsImg/"+myNews[indexPath.row].image!
                cell.NewsImage.setDownloadedImage(path: imgNewsPath)
                return cell
                
            }
         
            
        }else{
            
            return UITableViewCell()
            
        }
        
        
        
    }
    
    var isEvent:Bool?
    var myEvents:[Event] = []
    var myNews:[News] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var myCreationTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        EventController.shared.eventByUserResponseNotifier = self
        NewsController.shared.newsByUserResponseNotifier = self
        
        self.myCreationTableView.delegate = self
        self.myCreationTableView.dataSource = self
        
        if let isEvent = isEvent {
            
            if isEvent
            {
                
                self.titleLabel.text = "My event"
                self.subTitleLabel.text = "All event created by me"
                self.myCreationTableView.register(UINib.init(nibName: "MyEventTableViewCell", bundle: nil), forCellReuseIdentifier: "MyEventTableViewCell")
                self.myCreationTableView.rowHeight = 233
                
                if let user = user {
                    EventController.shared.getEventByUser(iduser: user._id!)

                }
                
            }else{
           
                self.titleLabel.text = "My news"
                self.subTitleLabel.text = "All news added by me"
                self.myCreationTableView.register(UINib.init(nibName: "MyNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "MyNewsTableViewCell")
                self.myCreationTableView.rowHeight = 240
                
                if let user = user {
                    NewsController.shared.getNewsByUser(iduser: user._id!)

                }
            }
        }
    }
    

    @IBAction func goBackToPrevious(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

    
    

}
