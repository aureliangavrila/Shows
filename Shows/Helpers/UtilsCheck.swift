//
//  UtilsCheck.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

open class UtilsCheck {
    
     static func checkEmail(email: String) -> Bool {
        return email.count != 0 && isValidEmail(email: email)
     }
     
    static func isValidEmail(email:String) -> Bool {
         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         
         let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailTest.evaluate(with: email)
     }
    
    static func checkPassword(password: String) -> Bool {
        return password.count >= 6
    }
    
    static func checkFormatSeasonAndEpisode(text: String) -> (String, String)? {
        let components = text.components(separatedBy: " ")
        
        guard components.count == 2 else {
            return nil
        }
        
        guard components[0].starts(with: "S") && components[1].starts(with: "E") else {
            return nil
        }
        
        let season = components[0]
        let epsiode = components[1]
        
        let rangeSeson = season.index(after: season.startIndex)..<season.endIndex
        let rangeEpisode = epsiode.index(after: epsiode.startIndex)..<epsiode.endIndex
        
        let seasonNr = season[rangeSeson]
        let episodeNr = epsiode[rangeEpisode]
        
        let strSeasonNr = String(seasonNr)
        let strEpisodeNr = String(episodeNr)
        
        guard Int(strSeasonNr) != nil && Int(strEpisodeNr) != nil else {
            return nil
        }
        
        return (strSeasonNr, strEpisodeNr)
    }
}
