//
//  ShowsError.swift
//  Shows
//
//  Created by mac on 02/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

enum SError: CustomStringConvertible, Error {
    
    case invalidUser
    
    case unknown
    
    case apiError(message: String)
    
    var description: String {
        switch self {
        case .invalidUser:
            return "There is no user with these credentials"
        
        case .unknown:
            return "We cannot process your request. \n Please try again."
            
        case .apiError(let message):
            return message
        }
    }
    
}
