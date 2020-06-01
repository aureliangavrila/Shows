//
//  Episode.swift
//  Shows
//
//  Created by mac on 01/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation


struct Episode {
    
    let id: String
    var description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    let title: String
    
    static func create(json: [String : AnyObject]) -> Episode {
        let id = json["_id"] as! String
        let imageURL = json["imageUrl"] as! String
        let description = json["description"] as! String
        let title = json["title"] as! String
        let episodeNr = json["episodeNumber"] as! String
        let season = json["season"] as! String
        
        return Episode(id: id, description: description, imageUrl: imageURL, episodeNumber: episodeNr, season: season, title: title)
    }
}
