//
//  APIConstants.swift
//  OnTheMap 1.0
//
//  Created by M7md on 26/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct APIConstants {
    
    struct headerKeys {
        static let AppId = "X-Parse-Application-Id"
        static let AppKey = "X-Parse-REST-API-Key"
    }
    
    struct headerValues {
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    struct parameterKeys {
        static let Limit = "limit"
        static let Order = "order"
        static let SKIP = "skip"
    }
    private static let MAINURL = "https://onthemap-api.udacity.com/v1"
    static let SESSION = MAINURL + "/session"
    static let PUBLIC_USER = MAINURL + "/users"
    static let STUDENT_LOCATION = MAINURL + "/StudentLocation"
    
    
}

enum HTTPMethod : String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
}
