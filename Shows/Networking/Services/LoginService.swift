//
//  LoginService.swift
//  Shows
//
//  Created by mac on 25/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

class LoginService {
    
    static let shared = LoginService()
    
    fileprivate var networkTask: SNetworkTask!
    
    func getUser(_ email: String, password: String, completion: @escaping (_ succes: Bool, _ error: Error?) -> Void ){
        networkTask = SNetworkTask(route: SAPIRouter.login(email, password: password))
        
        networkTask.stat { (result) in
            switch result {
            case .success(let data):
                
                guard data != nil else {
                    completion(false, nil)
                    
                    return
                }
                
                guard let json = JSONParser.shared.parseToJSON(data!) else {
                    completion(false, nil)
                    
                    return
                }
            
                guard let jsonData = json["data"] as? [String : Any] else {
                    completion(false, nil)

                    return
                }

                guard let token = jsonData["token"] as? String else {
                    completion(false, nil)

                    return
                }

                SAPIRouter.sessionToken = token
                
                completion(true, nil)
                
            case .failure(let error):
                completion(false, error)
            }
        }
        
    }
}
