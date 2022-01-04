

import Foundation
import UIKit

protocol NewsResponseNotifier{
    
    func showLoading()
    func allNewsDidFetched(news:[News])
    func serverNotResponding()
    
}

protocol AddNewsResponseNotifier{
    
    func showLoading()
    func newsDidCreated()
    func serverNotResponding()
    
}

protocol AddCommentNewsResponseNotifier{
    
    func showLoading()
    func commentNewsDidCreated()
    func serverNotResponding()
    
}

protocol DeleteNewsResponseNotifier
{
    
    func showLoading()
    func newsDeletedSuccessfully()
    func serverNotResponding()
    
}

protocol CommentByNewsResponseNotifier
{
    
    func showLoadingFetchComment()
    func allCommentsDidFetched(comments:[Comment])
    func serverNotRespondingFetchComment()
    
}


protocol NewsByUserResponseNotifier
{
    
    func showLoadingNews()
    func newsByUserDidFetched(news:[News])
    func serverNotRespondingNews()
    
}

protocol LikeDislikeNewsResponseNotifier
{
    
    func showLoadingNewsLikeDislike()
    func newsLiked()
    func newsDisLiked()
    func serverNotRespondingNewsLikeDislike()
    
}


class NewsController
{
    
    var newsNotifier:NewsResponseNotifier!
    var addNewsNotifier:AddNewsResponseNotifier!
    var deleteNewsNotifier:DeleteNewsResponseNotifier!
    var AddCommentNewsResponseNotifier:AddCommentNewsResponseNotifier!
    var commentByNewsResponseNotifier:CommentByNewsResponseNotifier!
    var newsByUserResponseNotifier:NewsByUserResponseNotifier!
    var likeDislikeNewsResponseNotifier:LikeDislikeNewsResponseNotifier!
    
    static let shared: NewsController = {
            let instance = NewsController()
            return instance
        }()
    
    func getNews()
    {
        self.newsNotifier.showLoading()

        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/news", method: .get, params:  [:], responseHandler: {
            
            (status, body:[News]?) in
           
                if status == 200
                {
                    if let news = body
                    {
                    
                        self.newsNotifier.allNewsDidFetched(news: news)
                    
                    }else{
                        self.newsNotifier.serverNotResponding()
                    }
                }else{
                    self.newsNotifier.serverNotResponding()
                }
            
        })
        
    }
    
    
    func getNewsByUser(iduser:String)
    {
        
        self.newsByUserResponseNotifier.showLoadingNews()
        let params = ["iduser":iduser]
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/getNewsByUser", method: .post, params: params, responseHandler: {
            
            (status, body:[News]?) in
           
                if status == 200
                {
                    if let news = body
                    {
                    
                        self.newsByUserResponseNotifier.newsByUserDidFetched(news: news)
                    
                    }else{
                        self.newsByUserResponseNotifier.serverNotRespondingNews()
                    }
                }else{
                    self.newsByUserResponseNotifier.serverNotRespondingNews()
                }
            
        })
        
    }
    
    
    func likeDislikeNews(iduser:String,idnews:String)
    {
        
        self.likeDislikeNewsResponseNotifier.showLoadingNewsLikeDislike()
        let params = ["iduser":iduser,"idnews":idnews]
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/likeDislikeNews", method: .post, params: params, responseHandler: {
            
            (status, body:[News]?) in
           
                if status == 202
                {
                    self.likeDislikeNewsResponseNotifier.newsLiked()
                    
                }else if status == 203
                {
                    self.likeDislikeNewsResponseNotifier.newsDisLiked()
                    
            }else{
                self.likeDislikeNewsResponseNotifier.serverNotRespondingNewsLikeDislike()
                
            }
            
        })
        
    }
    
    
    
    func getCommentsByNews(idnews:String)
    {
        self.newsNotifier.showLoading()
        let params = ["idnews":idnews]
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/getCommentsByNews", method: .post, params: params, responseHandler: {
            
            (status, body:[Comment]?) in
           
                if status == 200
                {
                    if let comments = body
                    {
                    
                        self.commentByNewsResponseNotifier.allCommentsDidFetched(comments: comments)
                    
                    }else{
                        self.commentByNewsResponseNotifier.serverNotRespondingFetchComment()
                    }
                }else{
                    self.commentByNewsResponseNotifier.serverNotRespondingFetchComment()
                }
            
        })
        
    }
    
    func deleteNews(idnews:String)
    {
        
        self.deleteNewsNotifier.showLoading()
        let params = ["idnews":idnews]
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/deleteNews", method: .post, params: params, responseHandler: {
            
            (status, body:VoidWSResponse?) in
           
                if status == 200
                {
                    self.deleteNewsNotifier.newsDeletedSuccessfully()

                }else{
                    self.deleteNewsNotifier.serverNotResponding()
                }
            
        })
        
    }
    
    func addComment(idnews:String,comment:String,iduser:String)
    {
        
        self.AddCommentNewsResponseNotifier.showLoading()
        let params = ["idnews":idnews,"comment":comment,"iduser":iduser]
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/addComment", method: .post, params: params, responseHandler: {
            
            (status, body:VoidWSResponse?) in
           
                if status == 200
                {
                    self.AddCommentNewsResponseNotifier.commentNewsDidCreated()

                }else{
                    self.AddCommentNewsResponseNotifier.serverNotResponding()
                }
            
        })
        
    }
    
    
    func addNews(news:News,image:UIImage,user:User)
    {
        
        self.addNewsNotifier.showLoading()
        let params = ["title":news.title!,"desc":news.desc!,"file":image,"iduser":user._id!] as [String : Any]
        
        WebServiceProvider.shared.callWebServiceWithFormData(URL: Utils.URL + "/addnews", method: .post, params:  params, responseHandler: {
            
            (status, body:VoidWSResponse?) in
           
                if status == 201
                {
                    
                    self.addNewsNotifier.newsDidCreated()
                    
                }else{
                    
                    self.newsNotifier.serverNotResponding()
                
                }
            
        })
        
        
        
    }
    
}
