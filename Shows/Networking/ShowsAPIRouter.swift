//
//  ShowsAPIRouter.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import Alamofire

enum SAPIRouter {
    case  login(email: String, password: String)
    
}

extension SAPIRouter {
    public var baseURL: URL {
        return URL(string: "https://api.infinum.academy/api")!
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/sessions"
        }
    }
    
    var parameters: Parameters? {
        
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        }
    }
}
