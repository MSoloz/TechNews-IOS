
import UIKit

class ParticipantsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var participantsTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.participantsTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
    
        let imgUserPath = Utils.URL_IMAGE_PATH+"USERImg/" + self.participants[indexPath.row].user!.image!
        
        cell.userImage.setDownloadedImage(path: imgUserPath)
        cell.usernameLabel.text = self.participants[indexPath.row].user!.prenom! + " " + self.participants[indexPath.row].user!.nom!
        
        return cell
    }
    var _participants:[Participation]?
    var participants:[Participation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        participantsTableView.delegate = self
        participantsTableView.dataSource = self
        participantsTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        
        if let _participants = _participants {
            
            participants = _participants
            self.participantsTableView.reloadData()
            
        }


    }
    
}
