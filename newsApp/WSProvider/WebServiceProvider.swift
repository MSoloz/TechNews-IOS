import Alamofire
import Foundation
import AlamofireImage

struct VoidWSResponse:Codable
{
    
}

class WebServiceProvider
{

    static let shared: WebServiceProvider = {
            let instance = WebServiceProvider()
            return instance
        }()
    
    func callWebService<T:Codable>(URL:String,method:HTTPMethod,params:[String:String]?,responseHandler: @escaping (Int,T?) -> ())
    {
        
        let dataRequest:DataRequest?
        
        if let params = params
        {
            
            if params.isEmpty == false{
                
                dataRequest = AF.request(URL, method: method,parameters: ((params as NSDictionary) as! Parameters))

            }else{
                dataRequest = AF.request(URL, method: method)
            }
            
        }else{
            
            dataRequest = AF.request(URL, method: method)
        
        }
        
        dataRequest!.validate().response { apiResponse in

            if let res = apiResponse.response
            {
                guard apiResponse.error == nil else{
                  
                    
                    responseHandler(res.statusCode,nil)
                    return
                }

                if let resBody = try? apiResponse.result.get()
                {
                    do{
                        
                        let decodedRes = try JSONDecoder().decode(T.self, from: resBody)
                        responseHandler(res.statusCode,decodedRes)

                    }catch{
              
                        responseHandler(res.statusCode,nil)
                    }
             
                }else{
          
                    responseHandler(res.statusCode,nil)
          
                }
              
            }else{
               
                responseHandler(404,nil)
            }
            
        }
        
    }
 

    func callWebServiceWithFormData<T:Codable>(URL:String,method:HTTPMethod,params:[String:Any]?,responseHandler: @escaping (Int,T?) -> ())
    {
                
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data"]
        
        if let params = params
        {
            if params.isEmpty == false{
                
               AF.upload(
                        
                    multipartFormData: { multipartFormData in
                       
                        for (key, value) in params {

                            if let img =  value as? UIImage
                            {
                                multipartFormData.append(img.jpegData(compressionQuality: 0.5)!, withName: key , fileName: "image.jpeg", mimeType: "image/jpeg")
                                
                            }else if let valueStr =  value as? String
                            {
                                multipartFormData.append((valueStr.data(using: .utf8))!, withName: key)

                            } else{
                                
                                responseHandler(404,nil)

                            }

                        }
                    
                    },to: URL, method: method ,headers: headers).validate().response { apiResponse in
                        
                        if let res = apiResponse.response
                        {
                            guard apiResponse.error == nil else{
                              
                                responseHandler(res.statusCode,nil)
                                return
                                
                            }

                            if let resBody = try? apiResponse.result.get()
                            {
                                do{

                                    let decodedRes = try JSONDecoder().decode(T.self, from: resBody)
                                    responseHandler(res.statusCode,decodedRes)

                                }catch{
                          
                                    responseHandler(res.statusCode,nil)
                                }
                         
                            }else{
                      
                                responseHandler(res.statusCode,nil)
                      
                            }
                          
                        }else{
                           
                            responseHandler(404,nil)
                        }
                        
                    }
                    
            }else{

                responseHandler(404,nil)
            }

        }else{
            
            responseHandler(404,nil)
        }
        
       
    }
    
    
    func downloadImage(url:String,responseImageHandler: @escaping (UIImage) -> ())
    {
        AF.request(url).responseImage { response in
            
            if case .success(let image) = response.result {
                
                responseImageHandler(image)
                    
            }
        }
        
    }
    
}
