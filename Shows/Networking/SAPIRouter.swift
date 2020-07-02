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
    
    case getShowEpisodes(_ showId: String)
    
    
    case getCommentsForEpisode(_ episodeId: String)
    case postComment(_ episodeId: String, comment: String)
    
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
            
        case .getShowEpisodes(let showId):
            return "/api/shows/\(showId)/episodes"
            
        case .getCommentsForEpisode(let episodeId):
            return "/api/episodes/\(episodeId)/comments"
            
        case .postComment:
            return "/api/comments"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login,
             .postComment:
            
            return .post
        
        case .getShows,
             .getShowInfo,
             .getShowEpisodes,
             .getCommentsForEpisode:
            
            return .get
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case .login(let email, let password):
            return ["email":email, "password":password]
            
        case .postComment(let epiosdeId, let comment):
            return ["text": comment, "episodeId": epiosdeId]
            
        case .getShows,
             .getShowInfo,
             .getShowEpisodes,
             .getCommentsForEpisode:
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
        
        case .getShows,
             .getShowInfo,
             .getShowEpisodes,
             .getCommentsForEpisode,
             .postComment:
            
            defaultHeaders["Authorization"] = SAPIRouter.sessionToken
            
            return defaultHeaders
        }
    }
}
