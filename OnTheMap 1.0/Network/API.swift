//
//  API.swift
//  OnTheMap 1.0
//
//  Created by M7md on 26/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class API {
    
    private static var sessionId : String?
    private static var userInfo = UserInfo()
    
    

    static func postSession (userName : String , password : String , completion : @escaping (String? ) -> Void){
        guard let url = URL(string : APIConstants.SESSION) else {
            print("url is not work")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorMessage : String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode < 400 {
            
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range)
            if let json = try? JSONSerialization.jsonObject(with: newData! , options: []) , let dict = json as? [String : Any] , let sessionDict = dict["session"] as? [String : Any] , let accountDict = dict["account"] as? [String:Any] {
                self.sessionId = sessionDict["id"] as? String
                self.userInfo.key = accountDict["key"] as? String
                
                getPublicUserName()
            } else {
             errorMessage = "Could not parse response "
            }
                } else{
                        errorMessage = "No matching"
                    }
            } else {
             errorMessage = "check your connection"
            }
            DispatchQueue.main.async {
                completion(errorMessage)
            }
        }
        task.resume()
    }
    
    
    static func deleteSession(completion: @escaping (Error?)->Void ){
        guard let url = URL(string: APIConstants.SESSION) else {
            print ("url is not working")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(error)
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            DispatchQueue.main.async {
                completion(nil)
            }
        }
        task.resume()
    }
    
    
    static func getPublicUserName(completion : ((_ error: Error?) -> Void)? = nil){
        guard let url = URL(string: "\(APIConstants.PUBLIC_USER)/)") , let userId = userInfo.key else {
            completion?(NSError(domain: "URLError", code: 0, userInfo: nil))
            return
        }
        var request = URLRequest(url: url)
        request.addValue(self.sessionId! , forHTTPHeaderField: "session_id")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var firstName : String? = ""
            var lastName : String? = ""
            var nickname : String = ""
            if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode < 400 {
                    
                    let range = (5..<data!.count)
                    let newData = data?.subdata(in: range)
                    if let json = try? JSONSerialization.jsonObject(with: newData! , options: []) , let dict = json as? [String : Any] {
                        nickname = dict["nickname"] as? String ?? ""
                        firstName = dict["first_name"] as? String ?? nickname
                        lastName = dict["last_name"] as? String ?? nickname
                  
                userInfo.firstName = firstName
                userInfo.lastName = lastName
                    }
                }
            }
                DispatchQueue.main.async {
                    completion?(nil)
                }
    }
        task.resume()
}

 
    
class Parser {
    
    
    
    static func getStudentLocations (limit : Int = 100 , skip : Int = 0 , orderBy : SLParam = .updatedAt , completion : @escaping ([StudentLocation]?) -> Void ) {
        guard let url = URL(string : "\(APIConstants.STUDENT_LOCATION)?\(APIConstants.parameterKeys.Limit)=\(limit)&\(APIConstants.parameterKeys.SKIP)=\(skip)&\(APIConstants.parameterKeys.Order)=-\(orderBy.rawValue)") else {
           completion(nil)
            return
        }
       
       
        var request = URLRequest(url: url)
         request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(APIConstants.headerValues.AppId, forHTTPHeaderField: APIConstants.headerKeys.AppId)
        request.addValue(APIConstants.headerValues.ApiKey, forHTTPHeaderField: APIConstants.headerKeys.AppKey)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var studentLocations : [StudentLocation] = []
            if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode < 400 {
                    
                    if let json = try? JSONSerialization.jsonObject(with: data! , options: []) , let dict = json as? [String : Any] , let results = dict["results"] as? [Any] {
                      
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocation = try! JSONDecoder().decode(StudentLocation.self, from:data)
                            studentLocations.append(studentLocation)
                        }
                    }
                 }
            }
            DispatchQueue.main.async {
                completion(studentLocations)
            }
        }
        task.resume()
    }
    
    
    
    
    static func postLocation(_ location: StudentLocation, completion: @escaping(String?) -> Void){
        
        guard let url = URL(string: "\(APIConstants.STUDENT_LOCATION)")  , let accountId = userInfo.key else {
            completion("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue(APIConstants.headerValues.AppId, forHTTPHeaderField: APIConstants.headerKeys.AppId)
        request.addValue(APIConstants.headerValues.ApiKey, forHTTPHeaderField: APIConstants.headerKeys.AppKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(accountId)\", \"firstName\": \"\(userInfo.firstName!)\", \"lastName\": \"\(userInfo.lastName!)\",\"mapString\": \"\(location.mapString!)\", \"mediaURL\": \"\(location.mediaURL!)\",\"latitude\": \(location.latitude!), \"longitude\": \(location.longitude!)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errorMessage : String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode{
                if statusCode >= 400 {
                    errorMessage = "Couldn't post your location"
                }
            }else {
                    errorMessage = "Check your connection "
                }
                DispatchQueue.main.async {
                    completion(errorMessage)
                }
            
        }
        task.resume()
    }
    
}
}
