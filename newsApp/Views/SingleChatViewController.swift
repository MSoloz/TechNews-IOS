import UIKit
import SendBirdSDK

struct SingleMessage
{
    var username:String?
    var message:String?
    
}


class SingleChatViewController: UIViewController,SBDChannelDelegate,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate  {
    
    var messages:[SingleMessage] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.chatTableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        cell.messageTextView.text = self.messages[indexPath.row].message
        cell.usernameLabel.text = self.messages[indexPath.row].username
        
        return cell
    }

    @IBOutlet weak var otherProfileImageView: UIImageView!
    @IBOutlet weak var otherUsername: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
  
    var channelUrl:String?
    var otherUser:User?
    var me:User?
    
    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.register(UINib.init(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTableViewCell")
        self.messageTextView.delegate = self
        
        self.messageTextView.layer.cornerRadius = 4
        self.messageTextView.layer.borderWidth = 0.5
        self.messageTextView.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        
        if let otherUser = otherUser {
            
            self.otherUsername.text = otherUser.prenom! +  " " + otherUser.nom!
            
            let imgUserPath = Utils.URL_IMAGE_PATH+"USERImg/" + otherUser.image!
            otherProfileImageView.setDownloadedImage(path: imgUserPath)
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.otherProfileImageView.layer.cornerRadius = self.otherProfileImageView.frame.height / 2
        
        createChannel()
        loadOldMessages()
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func enterChannel()
    {

        SBDOpenChannel.getWithUrl(self.channelUrl!) { openChannel, error in

            guard let openChannel = openChannel, error == nil else {
                        return // Handle error.
                }

                openChannel.enter(completionHandler: { error in
                    guard error == nil else {
                    return
                        }
                        
                })
        }
    }
    
    func createChannel()
    {
        
        if let channelUrl = channelUrl {
            
            
            let sBDOpenChannelParams = SBDOpenChannelParams()
            sBDOpenChannelParams.name = "newSingleChat" + channelUrl
            
            sBDOpenChannelParams.channelUrl = channelUrl
            
            SBDMain.add(self, identifier: channelUrl)

            SBDOpenChannel.createChannel(with: sBDOpenChannelParams) { channel, error in

                if let error = error{
                    //channel already exists
                    if error.code == 400202
                    {
                        self.enterChannel()
                    }else{
                        return
                    }
                }else{
                    
                    self.enterChannel()

                }
             
            }
    
        }
        
    }
    
    
    func loadOldMessages()
    {
        
        
        if let channelUrl = channelUrl {

            SBDOpenChannel.getWithUrl(channelUrl) { openChannel, error in
                    guard let openChannel = openChannel, error == nil else {
                            return // Handle error.
                    }
                let listQuery = openChannel.createPreviousMessageListQuery()
                listQuery?.loadPreviousMessages(withLimit: 30, reverse: false, completionHandler: { (oldMessages, error) in
                    if error != nil {
                        // Handle error.
                    }
                    
                    for oldMsg in oldMessages!
                    {
                        var sMsg = SingleMessage()
                        sMsg.username = oldMsg.sender?.nickname
                        sMsg.message = oldMsg.message
                        self.messages.append(sMsg)
                        
                    }
                    
                    self.chatTableView.reloadData()
                    self.scrollToBottom()

                })
            }
            
        }
        
        
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        
        var singleMsg = SingleMessage()
        singleMsg.message = message.message
        singleMsg.username = message.sender?.nickname

        self.messages.append(singleMsg)
        self.chatTableView.reloadData()
        self.scrollToBottom()

    }

    @IBAction func sendBtnTapped(_ sender: Any) {
        
        let message = self.messageTextView.text!

        if message.isEmpty == false{
            
            if let channelUrl = channelUrl {

                SBDOpenChannel.getWithUrl(channelUrl) { openChannel, error in
                        guard let openChannel = openChannel, error == nil else {
                                return // Handle error.
                        }
                openChannel.sendUserMessage(message) { userMessage, error in

                    guard let userMessage = userMessage, error == nil else {
                                return // Handle error.
                        }
                    

                    var singleMsg = SingleMessage()
                    singleMsg.message = message
                    singleMsg.username = self.me!.prenom! + " " + self.me!.nom!
                    self.messageTextView.text = ""
                    self.messages.append(singleMsg)
                    self.chatTableView.reloadData()
                    self.scrollToBottom()
                    
                        }
                
                }
                
            }
            
        }
       
            
        }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            
            if self.messages.count > 0
            {
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
}
