//
//  SNetworkTask.swift
//  Shows
//
//  Created by mac on 18/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import Alamofire

class SNetworkTask: NSObject {
    
    let route: SAPIRouter
    var request: DataRequest?
    
    var sharedManager = Alamofire.Session()
    
    init(route: SAPIRouter) {
        self.route = route
        self.request = nil
    }
    
    func stat(completion: @escaping (Result<Data?, SError>) -> Void) {
        self.request = sharedManager.request(self.route).responseJSON(completionHandler: { (response) in
            
            switch response.result {
            case .success(_):
                
                completion(.success(response.data))
                
            case .failure( _):
                guard let statusCode =  response.response?.statusCode else {
                    completion(.failure(.unknown))
                    return
                }
                
                if statusCode == 401 {
                    completion(.failure(.invalidUser))
                }
                
                completion(.failure(.unknown))
            }
        })
    }
}
