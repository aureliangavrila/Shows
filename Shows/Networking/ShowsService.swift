//
//  ShowsService.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ShowServices {
    static let shared = ShowServices()
    
    var authToken: String = ""
    
    var headers: HTTPHeaders = ["Accept": "application/json",
                                "Content-Type" : "application/json"]
    
    let baseURL = "https://api.infinum.academy"
    
    private func start(_ path: String, method: HTTPMethod, paramters: [String : String]?, headers: HTTPHeaders, completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(baseURL + path,
                   method: method,
                   parameters: paramters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseJSON { (response) in
                completion(response)
        }
    }
    
    //MARK: - LOGIN
    
    func getUser(_ email: String, password: String, completion: @escaping (_ succes: Bool, _ error: Error?) -> Void ){
        start("/api/users/sessions",
              method: .post,
              paramters: ["email":email, "password":password],
              headers: headers) { (response) in
                
                switch response.result {
                case .success(let data):
                    
                    guard let json = data as? [String : AnyObject] else {
                        completion(false, nil)
                        return
                    }
                    
                    guard let data = json["data"] as? [String : AnyObject] else {
                        completion(false, nil)
                        return
                    }
                    
                    self.authToken = data["token"] as! String
                    
                    completion(true, nil)
                    
                case .failure( _):
                    
                    guard let statusCode =  response.response?.statusCode else {
                        completion(false, SError.unknown)
                        return
                    }
                    
                    if statusCode == 401 {
                        completion(false, SError.invalidUser)
                    }
                    
                    completion(false, SError.unknown)
                }
        }
    }
    
    //MARK: - MAIN
    
    func getShows(completion: @escaping (_ shows: [Show]?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        start("/api/shows",
              method: .get,
              paramters: nil,
              headers: headers) { (response) in
                
                switch response.result {
                case .success(let data):
                    
                    var arrTempShows = [Show]()
                    
                    guard let dataJSON = data as? [String : AnyObject] else {
                        completion([], nil)
                        return
                    }
                    
                    guard let arrayJSON = dataJSON["data"] as? [[String : AnyObject]] else {
                        completion([], nil)
                        return
                    }
                    
                    for json in arrayJSON {
                        let show = Show.create(json: json)
                        arrTempShows.append(show)
                    }
                    
                    completion(arrTempShows, nil)
                    
                case .failure(let afError):
                    completion(nil, SError.apiError(message: afError.localizedDescription))
                }
        }
    }
    
    func getShowInfo(_ show: Show, completion: @escaping (_ shows: Show?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        start("/api/shows/\(show.id)",
            method: .get,
            paramters: nil,
            headers: headers) { (response) in
                switch response.result {
                case .success(let data):
                    
                    var tempShow = show
                    
                    guard let json = data as? [String : AnyObject] else {
                        completion(show, nil)
                        return
                    }
                    
                    guard let data = json["data"] as? [String : AnyObject] else {
                        completion(show, nil)
                        return
                    }
                    
                    let description = data["description"] as? String
                    let type = data["type"] as? String
                    
                    tempShow.updateInfo(description, type: type)
                    
                    completion(tempShow, nil)
                    
                case .failure(let afError):
                    completion(nil, SError.apiError(message: afError.localizedDescription))
                }
        }
    }
    
    func getShowEpisodes(_ show: Show, completion: @escaping (_ shows: [Episode]?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        start("/api/shows/\(show.id)/episodes",
        method: .get,
        paramters: nil,
        headers: headers) { (response) in
            
            switch response.result {
            case .success(let data):
                
                var arrTempEpisodes = [Episode]()
                
                guard let dataJSON = data as? [String : AnyObject] else {
                    completion([], nil)
                    return
                }
                
                guard let arrayJSON = dataJSON["data"] as? [[String : AnyObject]] else {
                    completion([], nil)
                    return
                }
                
                for json in arrayJSON {
                    let ep = Episode.create(json: json)
                    arrTempEpisodes.append(ep)
                }
                
                completion(arrTempEpisodes, nil)
                
            case .failure(let afError):
                completion(nil, SError.apiError(message: afError.localizedDescription))
            }
        }
    }
    
    func getCommetnsForEpisode(_ episode: Episode, completion: @escaping (_ shows: [Comment]?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        start("/api/episodes/\(episode.id)/comments",
            method: .get,
            paramters: nil,
            headers: headers) { (response) in
                
                switch response.result {
                case .success(let data):
                    
                    var arrTempEpisodes = [Comment]()
            
                    guard let dataJSON = data as? [String : AnyObject] else {
                        completion([], nil)
                        return
                    }
                    
                    guard let arrayJSON = dataJSON["data"] as? [[String : AnyObject]] else {
                        completion([], nil)
                        return
                    }
                    
                    for json in arrayJSON {
                        let comment = Comment.create(json: json)
                        arrTempEpisodes.append(comment)
                    }
                    
                    completion(arrTempEpisodes, nil)
                    
                case .failure(let afError):
                    completion(nil, SError.apiError(message: afError.localizedDescription))
                }
        }
    }
    
    func postCommentForEpisode(_ episode: Episode, cooment: String,completion: @escaping (_ shows: Comment?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        start("/api/comments",
              method: .post,
              paramters: ["text": cooment, "episodeId": episode.id],
              headers: headers) { (response) in
                
                switch response.result {
                case .success(let data):
                    
                    guard let json = data as? [String : AnyObject] else {
                        completion(nil, nil)
                        return
                    }
                    
                    guard let data = json["data"] as? [String : AnyObject] else {
                        completion(nil, nil)
                        return
                    }
                    
                    let comment = Comment.create(json: data)
                    
                    completion(comment, nil)
                    
                case .failure(let afError):
                    completion(nil, SError.apiError(message: afError.localizedDescription))
                }
        }
    }
    
    private func createEpisode(_ showId: String, title: String, season: String, episode: String, description: String, mediaId: String,
                               completion: @escaping (_ succes: Bool, _ error: Error?) -> Void ) {
        
        headers["Authorization"] = authToken
        
        let parameters = ["showId" : showId,
                          "mediaId" : mediaId,
                          "title" : title,
                          "description" : description,
                          "episodeNumber" : episode,
                          "season" : season]
        
        start("/api/episodes",
              method: .post,
              paramters: parameters,
              headers: headers) { (response) in
                
                switch response.result {
                case .success( _):
                    completion(true, nil)
                    
                case .failure(let afError):
                    completion(false, SError.apiError(message: afError.localizedDescription))
                }
        }
    }
    
    func addEpisode(_ image: UIImage, showId: String, title: String, season: String, episode: String, description: String,
                    completion: @escaping (_ succes: Bool, _ error: Error?) -> Void ) {
        
        let headers: HTTPHeaders = ["Content-type" : "multipart/form-data",
                                    "Content-Disposition" : "form-data",
                                    "Authorization" : authToken]
        
        let parameters: [String : AnyObject] = ["file": image]
        
        
       let uploadRequst =  AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }

            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
            multipartFormData.append(imageData, withName: "file", fileName: "file.jpg", mimeType: "image/jpeg")

        }, to:baseURL + "/api/media",
           method: .post,
           headers: headers)
        
        uploadRequst.responseJSON { (response) in
            switch response.result {
            case .success(let data):

                guard let dataJSON = data as? [String : AnyObject] else {
                    return
                }
                
                guard let json = dataJSON["data"] as? [String : AnyObject] else {
                    return
                }
                
                guard let mediaId = json["_id"] as? String else {
                    return
                }
                
                self.createEpisode(showId, title: title, season: season, episode: episode, description: description, mediaId: mediaId) { (success, error) in
                    completion(success, error)
                }
                
            case.failure(let afError):
                completion(false, SError.apiError(message: afError.localizedDescription))
            }
        }
    }
    
    
}
