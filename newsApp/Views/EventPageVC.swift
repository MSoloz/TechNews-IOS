import UIKit

class EventsPageVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,EventResponseNotifier{
    
    func showLoading() {
        LoadingView.shared.showLoadingView(view: self.view)

    }
    
    func eventDidFetched(events: [Event]) {
        
        LoadingView.shared.dismissLoadingView()
        self.events = events
        self.tableViewE.reloadData()
        
    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    
    }
    
    
    @IBOutlet weak var tableViewE: UITableView!

    var events : [Event] = []
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        EventController.shared.getAllEvent()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EventController.shared.eventNotifier = self
        let nib = UINib(nibName: "EventCell", bundle: nil)
        
        self.tableViewE.register(nib, forCellReuseIdentifier: "mCell")
        self.tableViewE.delegate = self
        self.tableViewE.dataSource = self
        
        let floattingButton = FloatingButton.createFloatingButton(view: self.view)
        view.addSubview(floattingButton)
        floattingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
       
    }
    
    @objc private func didTapButton(){
        
        let addEvent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEventPageVC")
        self.navigationController?.pushViewController(addEvent, animated: true)
        
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mCell") as! EventCell
        cell.mLabel1.text = events[indexPath.row].name
        cell.mLabel2.text = events[indexPath.row].event_time
        cell.mLablel2.text = events[indexPath.row].adress
        
        cell.interestButton.setTitle(" " + events[indexPath.row].Interests!.count.description, for: .normal)
        cell.participationButton.setTitle(" " + events[indexPath.row].participants!.count.description, for: .normal)
            
        let imgEventPath = Utils.URL_IMAGE_PATH+"EventImg/"+events[indexPath.row].image!
        cell.mImage.setDownloadedImage(path: imgEventPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let eventDetail = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
        eventDetail.event = self.events[indexPath.row]
        self.navigationController?.pushViewController(eventDetail, animated: true)
        
    }
    
}
