//
//  EpisodesService.swift
//  Shows
//
//  Created by mac on 02/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation


class EpisodesService {
    static let shared = EpisodesService()
    
    fileprivate var networkTask: SNetworkTask!
    
    func getShowEpisodes(_ show: Show, completion: @escaping (_ episodes: [Episode]?, _ error: Error?) -> Void) {
        networkTask = SNetworkTask(route: SAPIRouter.getShowEpisodes(show.id))
        
        networkTask.stat { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    
                    guard data != nil else {
                        completion([], nil)
                        return
                    }
                    
                    guard let episodes = JSONParser.shared.parseJSON(ofType: Episodes.self, data!) else {
                        completion([], nil)
                        return
                    }
                    
                    completion(episodes.data, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    
}
