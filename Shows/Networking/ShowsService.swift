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
    
    func getUser(_ email: String, password: String, completion: @escaping (_ succes: Bool) -> Void ){
        AF.request(baseURL + "/api/users/sessions",
                 method: .post,
                 parameters: ["email":email, "password":password],
                 encoding: JSONEncoding.default,
                 headers: headers)
        .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let data):
                    if let json = data as? [String : Any] {
                        if let data = json["data"] as? [String : Any] {
                            self.authToken = data["token"] as! String
                            
                            completion(true)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
        }
    }
    
    
    func getShows(completion: @escaping (_ shows: [Show]?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        AF.request(baseURL + "/api/shows",
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseJSON { (response) in
                
                    switch response.result {
                    case .success(let data):
                    
                        var arrTempShows = [Show]()
                        if let dataJSON = data as? [String : AnyObject] {
                            if let arrayJSON = dataJSON["data"] as? [[String : AnyObject]] {
                                for json in arrayJSON {
                                    let show = Show.create(json: json)
                                    arrTempShows.append(show)
                                }
                            }
                        }
                        
                        completion(arrTempShows, nil)
                        
                    case .failure(let afError):
                        print(afError.localizedDescription)
                    }
                }
        }
    
    
    func getShowInfo(_ show: Show, completion: @escaping (_ shows: Show?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        AF.request(baseURL + "/api/shows/\(show.id)",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    
                    var tempShow = show
                    if let dataJSON = data as? [String : AnyObject] {
                        if let json = dataJSON["data"] as? [String : AnyObject] {
                            let description = json["description"] as? String
                            let type = json["type"] as? String
                            
                            tempShow.updateInfo(description, type: type)
                            
                            completion(tempShow, nil)
                        }
                    }
                    
                case .failure(let afError):
                    print(afError.localizedDescription)
                }
        }
    }
    
    func getShowEpisodes(_ show: Show, completion: @escaping (_ shows: [Episode]?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        AF.request(baseURL + "/api/shows/\(show.id)/episodes",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    
                    print(data)
                    var arrTempEpisodes = [Episode]()
                    if let dataJSON = data as? [String : AnyObject] {
                        if let arrayJSON = dataJSON["data"] as? [[String : AnyObject]] {
                            for json in arrayJSON {
                                let ep = Episode.create(json: json)
                                arrTempEpisodes.append(ep)
                            }
                        }
                    }
                    
                    completion(arrTempEpisodes, nil)
                case .failure(let afError):
                    print(afError.localizedDescription)
                }
        }
    }
    
    func getCommetnsForEpisode(_ episode: Episode, completion: @escaping (_ shows: [Comment]?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        AF.request(baseURL + "/api/episodes/\(episode.id)/comments",
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
            
                    var arrTempEpisodes = [Comment]()
                    if let dataJSON = data as? [String : AnyObject] {
                        if let arrayJSON = dataJSON["data"] as? [[String : AnyObject]] {
                            for json in arrayJSON {
                                let comment = Comment.create(json: json)
                                arrTempEpisodes.append(comment)
                            }
                        }
                    }
                    
                    completion(arrTempEpisodes, nil)
                    
                    completion(arrTempEpisodes, nil)
                case .failure(let afError):
                    print(afError.localizedDescription)
                }
        }
    }
    
    func postCommentForEpisode(_ episode: Episode, cooment: String,completion: @escaping (_ shows: Comment?, _ error: Error?) -> Void) {
        headers["Authorization"] = authToken
        
        AF.request(baseURL + "/api/comments",
            method: .post,
            parameters: ["text": cooment, "episodeId": episode.id],
            encoding: JSONEncoding.default,
            headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    print(data)
                    
                    if let dataJSON = data as? [String : AnyObject] {
                        if let json = dataJSON["data"] as? [String : AnyObject] {
                            let comment = Comment.create(json: json)
                            
                            completion(comment, nil)
                        }
                    }
                    
                case .failure(let afError):
                    print(afError.localizedDescription)
                }
        }
    }
    
    func addEpisode(_ image: UIImage, showId: String, title: String, season: String, episode: String, description: String) {
        
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
                print(data)
                guard let dataJSON = data as? [String : AnyObject] else {
                    return
                }
                
                guard let json = dataJSON["data"] as? [String : AnyObject] else {
                    return
                }
                
                guard let mediaId = json["_id"] as? String else {
                    return
                }
                
                self.createEpisode(showId, title: title, season: season, episode: episode, description: description, mediaId: mediaId)
                
            case.failure(let aferror):
                print(aferror.localizedDescription)
            }
        }
    }
    
    func createEpisode(_ showId: String, title: String, season: String, episode: String, description: String, mediaId: String) {
        headers["Authorization"] = authToken
        
        let parameters = ["showId" : showId,
                          "mediaId" : mediaId,
                          "title" : title,
                          "description" : description,
                          "episodeNumber" : episode,
                          "season" : season]
        
        AF.request(baseURL + "/api/episodes",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    print(data)
                    
                case .failure(let afError):
                    print(afError.localizedDescription)
                }
        }
    }
    
//    func imagupload(){
//        let upload_file = image
//
//        var parameters = [String:AnyObject]()
//        parameters = ["file": upload_file] as [String : AnyObject]
//
//        let URL = "myURL"
//
//
//        requestWith(endUrl: URL, imageData: image.jpegData(compressionQuality: 1.0), parameters: parameters, onCompletion: { (json) in
//            print(json)
//
//        }) { (error) in
//            print(error)
//
//        }
//    }


//      func requestWith(endUrl: String, imagedata: Data?, parameters: [String : String], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
//
//        let url = endUrl
//
//
//        let headers: HTTPHeaders = [
//
//            "Content-type": "multipart/form-data"
//        ]
//
//        AF.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in parameters {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//
//            if let data = imagedata{
//                multipartFormData.append(data, withName: "imagename", fileName: "imagename.jpg", mimeType: "image/jpeg")
//            }
//
//        }, to:url,headers: headers)
//        { (result) in
//            switch result {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    let json : JSON = JSON(response.result.value)
//                     print(json)
//                    if let err = response.error{
//                        onError?(err)
//
//                        return
//                    }
//                    onCompletion?(json)
//
//                }
//            case .failure(let error):
//               //print("Error in upload: \(error.localizedDescription)")
//                onError?(error)
//
//            }
//
//        }
//
//    }
    
}
