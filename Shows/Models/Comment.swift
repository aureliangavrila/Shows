//
//  Comment.swift
//  Shows
//
//  Created by mac on 01/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation


struct Comment {
    
    let id: String
    let episodeId: String
    let userEmail: String
    let text: String
    
    static func create(json: [String : AnyObject]) -> Comment {
        let id = json["_id"] as! String
        let episodeId = json["episodeId"] as! String
        let userEmail = json["userEmail"] as! String
        let text = json["text"] as! String
        
        return Comment(id: id, episodeId: episodeId, userEmail: userEmail, text: text)
    }
}
