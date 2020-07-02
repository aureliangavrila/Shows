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
                    
                    guard let shows = JSONParser.shared.parseJSON(ofType: Shows.self, data!) else {
                        completion([], nil)
                        return
                    }
                    
                    completion(shows.data, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func getShowInfo(_ show: Show, completion: @escaping (_ shows: Show?, _ error: Error?) -> Void) {
        networkTask = SNetworkTask(route: SAPIRouter.getShowInfo(show.id))
        
        networkTask.stat { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    
                    guard data != nil else {
                        completion(nil, nil)
                        return
                    }
                    
                    guard let show = JSONParser.shared.parseJSON(ofType: ShowInfo.self, data!) else {
                        completion(nil, nil)
                        return
                    }
                    
                    completion(show.data, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    
}
