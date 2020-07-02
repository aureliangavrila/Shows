//
//  ShowsService.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import Alamofire

class ShowServices {
    static let shared = ShowServices()
    
    var authToken: String = ""
    
    var headers: HTTPHeaders = ["Accept": "application/json",
                                "Content-Type" : "application/json"]
    
    let baseURL = Constants.baseURL
    
    fileprivate var networkTask: SNetworkTask!
    
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
    
    //MARK: - MAIN
    
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
