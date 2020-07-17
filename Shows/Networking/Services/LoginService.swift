//
//  LoginService.swift
//  Shows
//
//  Created by mac on 25/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

protocol SLoginServiceDelegate {
    func showSuccesLoginUser(success: Bool)
    func showError(error: SError)
}

class LoginService: SLoginPresenterModuleInterface {
    
    fileprivate var networkTask: SNetworkTask!
    
    var delegate: SLoginServiceDelegate?
    
    func getUser(_ email: String, password: String, completion: @escaping (_ succes: Bool, _ error: Error?) -> Void ) {
        networkTask = SNetworkTask(route: SAPIRouter.login(email, password: password))
        
        networkTask.stat { (result) in
            switch result {
            case .success(let data):
                
                guard data != nil else {
                    self.delegate?.showSuccesLoginUser(success: false)
                    
                    return
                }
                
                guard let json = JSONParser.shared.parseToJSON(data!) else {
                    self.delegate?.showSuccesLoginUser(success: false)
                    
                    return
                }
            
                guard let jsonData = json["data"] as? [String : Any] else {
                    self.delegate?.showSuccesLoginUser(success: false)

                    return
                }

                guard let token = jsonData["token"] as? String else {
                    self.delegate?.showSuccesLoginUser(success: false)

                    return
                }

                SAPIRouter.sessionToken = token
                
                completion(true, nil)
                self.delegate?.showSuccesLoginUser(success: true)
                
            case .failure(let error):
                self.delegate?.showError(error: error)
            }
        }
        
    }
}
