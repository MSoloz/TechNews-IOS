
import UIKit
import CoreLocation

class EventDetailViewController: UIViewController,DeleteEventResponseNotifier,InterestEventResponseNotifier,ParticipateEventResponseNotifier {
    
    
    func showLoadingEventParticipate() {
        LoadingView.shared.showLoadingView(view: self.view)
    }
    
    func participateAdded() {
        LoadingView.shared.dismissLoadingView()
        
        AlertResponseView.shared.showAlert(message: "Your participation has been added", viewController: self,handler: nil)
        self.participateButton.setTitle("Cancel participation", for: .normal)
        self.participateButton.tintColor = .red

        
    }
    
    func participateDeleted() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Your participation has been cancelled", viewController: self,handler: nil)
        self.participateButton.setTitle("Participate", for: .normal)
        //self.participateButton.tintColor = .tintColor

    }
    
    func serverNotRespondingEventParticipate() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)

    }
    
    func showLoadingEventInterest() {
        
    }
    
    func interestAdded() {
        
        self.interestButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    
    }
    
    func interestDisLiked() {
        
        self.interestButton.setImage(UIImage(systemName: "star"), for: .normal)

    }
    
    func serverNotRespondingEventInterest() {
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    
    
    
    
    func showLoading() {
        
        LoadingView.shared.showLoadingView(view: self.view)
    
    }
    
    func eventDeletedSuccessfully() {
        
        LoadingView.shared.dismissLoadingView()
        self.navigationController?.popViewController(animated: true)

    }
    
    func serverNotResponding() {
        
        LoadingView.shared.dismissLoadingView()
        AlertResponseView.shared.showAlert(message: "Something went wrong, please try later !", viewController: self,handler: nil)
    }
    

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventDateTime: UILabel!
    
    @IBOutlet weak var eventAdress: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
        
    
    @IBOutlet weak var participateButton: UIButton!
    @IBOutlet weak var interestButton: UIButton!
    
    @IBOutlet weak var viewParticipationButton: UIButton!
    
    var event:Event?
    
    let user:User? = {
        
       return UserLocalService.shared.getUser().first
    
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventController.shared.deleteEventNotifier = self
        EventController.shared.interestEventResponseNotifier = self
        EventController.shared.participateEventResponseNotifier = self
        
        if let event = event {
            self.eventTitle.text = event.name
            
            self.eventAdress.text = event.adress
            self.eventDateTime.text = event.event_time
            
            let imgEventPath = Utils.URL_IMAGE_PATH+"EventImg/"+event.image!
            self.eventImage.setDownloadedImage(path: imgEventPath)
            self.eventDescription.text = event.description
         
            
            self.viewParticipationButton.setTitle("View participation (" + event.participants!.count.description + ") " , for: .normal)
            if event.participants!.contains(where: { $0.user?._id! == self.user!._id! })
            {

                self.participateButton.setTitle("Cancel participation", for: .normal)
                self.participateButton.tintColor = .red
                
            }else{
                
                self.participateButton.setTitle("Participate", for: .normal)
                //self.participateButton.tintColor = .tintColor
                
            }
            
            if event.Interests!.contains(where: { $0.user?._id! == self.user!._id! })
            {
                self.interestButton.setImage(UIImage(systemName: "star.fill"), for: .normal)

            }else{
                
                self.interestButton.setImage(UIImage(systemName: "star"), for: .normal)

            }
            
        }
        
        if self.event?.creator?._id == self.user?._id
        {
            self.deleteBtn.isHidden = false
        }else{
            self.deleteBtn.isHidden = true

        }
    }
    
    @IBAction func showOnMapTapped(_ sender: Any) {
    
        let showMapEvent = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowMapEventViewController") as! ShowMapEventViewController
        
        if let event = event,let lat = event.lat,let lng = event.lng,let latCasted = Double(lat),let lngCasted = Double(lng) {
            showMapEvent.coordinate = CLLocationCoordinate2D(latitude: latCasted, longitude: lngCasted)
            self.present(showMapEvent, animated: true, completion: nil)
        }
     
    }
    
    
    @IBAction func returnBackToPrevious(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func deleteEventTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Deleting...", message: "Are you sure do you want to delete ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            
            if let event = self.event,let id = event._id {
                
                EventController.shared.deleteEvent(idevent: id)

            }

        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func interestTapped(_ sender: Any) {
        
        if let user = user, let event = event {
            
            EventController.shared.interestEvent(iduser: user._id!, idevent: event._id!)
            
        }
        
    }
    
    @IBAction func participateTapped(_ sender: Any) {
        
        EventController.shared.participateEvent(iduser: self.user!._id!, idevent: self.event!._id!)
        
    }
    
    @IBAction func viewParticipantsTapped(_ sender: Any) {
        
        let participantsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ParticipantsViewController") as! ParticipantsViewController
        
        participantsVC._participants = self.event!.participants
        self.present(participantsVC, animated: true, completion: nil)
        
        
    }
    

}
