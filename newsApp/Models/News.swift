

import Foundation


class News:Codable {
    
    var _id:String?
    var title :String?
    var desc:String?
    var image:String?
    var creator:User?
    var comments:[Comment]?
    var likes:[Like]?

    var __v:Int?

    
}
