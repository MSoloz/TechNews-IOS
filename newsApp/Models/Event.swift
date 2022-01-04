
import Foundation


class Event:Codable {
    
    var _id:String?
    var name :String?
    var description :String?
    var adress :String?
    var lat:String?
    var lng:String?
    var event_time:String?
    var image:String?
    var __v:Int?
    var creator:User?
    var participants:[Participation]?
    var Interests:[Interest]?
    
}
