//
//  CommentsService.swift
//  Shows
//
//  Created by mac on 02/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

class CommentsService {
    static let shared = CommentsService()
    
    fileprivate var networkTask: SNetworkTask!
    
    func getCommentsForEpisode(_ episode: Episode, completion: @escaping (_ comments: [Comment]?, _ error: Error?) -> Void) {
        networkTask = SNetworkTask(route: SAPIRouter.getCommentsForEpisode(episode.id))
        
        networkTask.stat { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    
                    guard data != nil else {
                        completion([], nil)
                        return
                    }
                    
                    guard let comments = JSONParser.shared.parseJSON(ofType: Comments.self, data!) else {
                        completion([], nil)
                        return
                    }
                    
                    completion(comments.data, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    func postCommentForEpisode(_ episode: Episode, cooment: String,completion: @escaping (_ comment: Comment?, _ error: Error?) -> Void) {
        networkTask = SNetworkTask(route: SAPIRouter.postComment(episode.id, comment: cooment))
        
        networkTask.stat { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    
                    guard data != nil else {
                        completion(nil, nil)
                        return
                    }
                    
                    guard let comment = JSONParser.shared.parseJSON(ofType: CommentInfo.self, data!) else {
                        completion(nil, nil)
                        return
                    }
                    
                    completion(comment.data, nil)
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}
