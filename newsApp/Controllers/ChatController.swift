import Foundation

protocol GetChatResponseNotifier
{
    
    func showLoadingChat()
    func chatDidFound(chat:Chat,user:User,other:User)
    func serverNotRespondingChat()
    
}

class ChatController
{
    var getChatResponseNotifier:GetChatResponseNotifier!
    
    static let shared: ChatController = {
            let instance = ChatController()
            return instance
        }()
    
    
    func getChat(user:User,other:User)
    {
    
        self.getChatResponseNotifier.showLoadingChat()
        
        let params = ["id":user._id!,"otherid":other._id!]

        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/getChatByUser", method: .post, params:  params, responseHandler: {
            
            (status, body:Chat?) in
           
                if status == 200
                {
                    if let chat = body
                    {
                        
                        self.getChatResponseNotifier.chatDidFound(chat: chat,user:user,other: other)
                    
                    }else{
                        self.getChatResponseNotifier.serverNotRespondingChat()
                    }
                }else{
                    self.getChatResponseNotifier.serverNotRespondingChat()
                }
            
        })
        
    
    }
    
}
