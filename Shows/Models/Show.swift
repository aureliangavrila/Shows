//
//  Show.swift
//  Shows
//
//  Created by mac on 01/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation


struct Show {
    
    let id: String
    let imageUrl: String
    let likesCount: Int
    let title: String
    
    var description: String?
    var type: String?
    var episodes: [Episode]?
    
    static func create(json: [String : AnyObject]) -> Show {
        let id = json["_id"] as! String
        let imageURL = json["imageUrl"] as! String
        let likesCount = json["likesCount"] as! Int
        let title = json["title"] as! String
        
        return Show(id: id, imageUrl: imageURL, likesCount: likesCount, title: title)
    }
    
     mutating func updateInfo(_ description: String?, type: String?) {
        self.description = description
        self.type = type
    }
    
    mutating func addEpisodes(_ episodes: [Episode]?) {
        self.episodes = episodes
    }
}
