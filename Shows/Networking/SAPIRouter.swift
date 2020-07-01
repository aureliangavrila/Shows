//
//  SAPIRouter.swift
//  Shows
//
//  Created by mac on 16/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import Alamofire

typealias Headers = [String:String]
typealias Json = [String:Any]

enum SAPIRouter {
    static var sessionToken = ""

    case login(_ email: String, password: String)
    
    case getShows
    case getShowInfo(_ showId: String)
    
}

extension SAPIRouter: Alamofire.URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: Constants.baseURL + path)!)
        
        urlRequest.httpMethod = method.rawValue
        
        // Add any additional HTTP headers
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        let params = parameters
        
        return try JSONEncoding.default.encode(urlRequest, withJSONObject: params)
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/users/sessions"
            
        case .getShows:
            return "/api/shows"
            
        case .getShowInfo(let showId):
            return "/api/shows/\(showId)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        
        case .getShows, .getShowInfo:
            return .get
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .login(let email, let password):
            return ["email":email, "password":password]
            
        case .getShows, .getShowInfo:
            return nil
        }
    }
    
    var headers: Headers {
        var defaultHeaders = Headers()
        
        defaultHeaders["Accept"] = "application/json"
        defaultHeaders["Content-Type"] = "application/json"
        
        switch self {
        case .login:
            return defaultHeaders
        
        case .getShows, .getShowInfo:
            defaultHeaders["Authorization"] = SAPIRouter.sessionToken
            
            return defaultHeaders
        }
    }
}
