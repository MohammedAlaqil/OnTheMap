//
//  StudentLocation.swift
//  OnTheMap 1.0
//
//  Created by M7md on 26/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct StudentLocation {
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString: String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
    
    var labelName: String {
    var name = ""
        if let first = firstName , let last = lastName {
        name = first + last
       
         }
         return name
    }
}

extension StudentLocation : Codable {}

enum SLParam : String {
    case createdAt , firstName , lastName , latitude , longitude , mapString , mediaURL , objectId , uniqueKey , updatedAt
}
