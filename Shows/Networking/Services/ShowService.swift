//
//  ShowService.swift
//  Shows
//
//  Created by mac on 01/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

class ShowService {
    static let shared = ShowService()
    
    fileprivate var networkTask: SNetworkTask!
    
    func getShows(completion: @escaping (_ shows: [Show]?, _ error: Error?) -> Void) {
        networkTask = SNetworkTask(route: SAPIRouter.getShows)
        
        networkTask.stat { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let data):
                    
                    guard data != nil else {
                        completion([], nil)
                        return
                    }
                    
                    let jsonDecoder = JSONDecoder()
                    
                    do {
                        let shows = try jsonDecoder.decode(Shows.self, from: data!)
                        completion(shows.data, nil)
                    }
                    catch (let error) {
                        print(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
