import Foundation
import UIKit

protocol AddEventResponseNotifier
{
    
    func showLoading()
    func eventDidCreated()
    func serverNotResponding()
    
}

protocol EventResponseNotifier
{
    
    func showLoading()
    func eventDidFetched(events:[Event])
    func serverNotResponding()
    
}
    
protocol DeleteEventResponseNotifier
{
    
    func showLoading()
    func eventDeletedSuccessfully()
    func serverNotResponding()
    
}

protocol EventByUserResponseNotifier
{
    
    func showLoadingEvent()
    func EventByUserDidFetched(events:[Event])
    func serverNotRespondingEvent()
    
}

protocol InterestEventResponseNotifier
{
    
    func showLoadingEventInterest()
    func interestAdded()
    func interestDisLiked()
    func serverNotRespondingEventInterest()
    
}

protocol ParticipateEventResponseNotifier
{
    
    func showLoadingEventParticipate()
    func participateAdded()
    func participateDeleted()
    func serverNotRespondingEventParticipate()
    
}

class EventController
{
 
    var addEventNotifier : AddEventResponseNotifier!
    var eventNotifier : EventResponseNotifier!
    var deleteEventNotifier : DeleteEventResponseNotifier!
    var eventByUserResponseNotifier:EventByUserResponseNotifier!
    var interestEventResponseNotifier:InterestEventResponseNotifier!
    var participateEventResponseNotifier:ParticipateEventResponseNotifier!
    
    
    static let shared: EventController = {
            let instance = EventController()
            return instance
        }()
    
    func deleteEvent(idevent:String)
    {
        
        self.deleteEventNotifier.showLoading()
        let params = ["idevent":idevent]
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/deleteEvent", method: .post, params: params, responseHandler: {
            
            (status, body:VoidWSResponse?) in
           
                if status == 200
                {
                    self.deleteEventNotifier.eventDeletedSuccessfully()

                }else{
                    self.deleteEventNotifier.serverNotResponding()
                }
            
        })
        
    }
    
    
    func getAllEvent()
    {
        
        self.eventNotifier.showLoading()

        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/events", method: .get, params:  [:], responseHandler: {
            
            (status, body:[Event]?) in
           
                if status == 200
                {
                    if let events = body
                    {
                        
                        self.eventNotifier.eventDidFetched(events: events)
                    
                    }else{
                        self.eventNotifier.serverNotResponding()
                    }
                }else{
                    self.eventNotifier.serverNotResponding()
                }
            
        })
        
    }
    
    
    func addEvent(event:Event,image:UIImage,user:User)
    {
        
        addEventNotifier.showLoading()
        
        if let name = event.name,let eventTime = event.event_time
        {
            
            let params = ["name":name,"description":event.description!,"event_time":eventTime,"file":image,"iduser":user._id!,"adress":event.adress!,"lat":event.lat!,"lng":event.lng!] as [String : Any]
            
            WebServiceProvider.shared.callWebServiceWithFormData(URL: Utils.URL + "/addevent", method: .post, params:  params, responseHandler: {
                
                (status, body:VoidWSResponse?) in
               
                    if status == 201
                    {
                        
                        self.addEventNotifier.eventDidCreated()
                        
                    }else{
                        
                        self.addEventNotifier.serverNotResponding()
                    
                    }
                
            })
            
        }
      
        
    }
    
    
    func getEventByUser(iduser:String)
    {
        
        self.eventByUserResponseNotifier.showLoadingEvent()
        let params = ["iduser":iduser]
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/getEventByUser", method: .post, params: params, responseHandler: {
            
            (status, body:[Event]?) in
           
                if status == 200
                {
                    
                    if let events = body
                    {
                        self.eventByUserResponseNotifier.EventByUserDidFetched(events: events)
                    }else{
                        self.eventByUserResponseNotifier.serverNotRespondingEvent()
                    }
                        
                }else{
                    self.eventByUserResponseNotifier.serverNotRespondingEvent()
                }
            
        })
        
    }
    
    func interestEvent(iduser:String,idevent:String)
    {
            
        self.interestEventResponseNotifier.showLoadingEventInterest()
        
        let params = ["iduser":iduser,"idevent":idevent]
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/InterestEvent", method: .post, params: params, responseHandler: {
            
            (status, body:[News]?) in
           
                if status == 202
                {
                    self.interestEventResponseNotifier.interestAdded()
                    
                }else if status == 203
                {
                    self.interestEventResponseNotifier.interestDisLiked()
                    
            }else{
                self.interestEventResponseNotifier.serverNotRespondingEventInterest()
                
            }
            
        })
        
    }
    
    
    func participateEvent(iduser:String,idevent:String)
    {
            
        self.participateEventResponseNotifier.showLoadingEventParticipate()
        
        let params = ["iduser":iduser,"idevent":idevent]
        
        WebServiceProvider.shared.callWebService(URL: Utils.URL + "/participateEvent", method: .post, params: params, responseHandler: {
            
            (status, body:[News]?) in
           
                if status == 202
                {
                    self.participateEventResponseNotifier.participateAdded()
                    
                }else if status == 203
                {
                    self.participateEventResponseNotifier.participateDeleted()
                    
            }else{
                self.participateEventResponseNotifier.serverNotRespondingEventParticipate()
                
            }
            
        })
        
    }
    
}
