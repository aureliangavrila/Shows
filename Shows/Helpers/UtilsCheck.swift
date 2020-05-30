//
//  UtilsCheck.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

open class UtilsCheck {
    
     class func checkEmail(email: String) -> Bool {
         var valid = false;
         
         if (email.count == 0) {
             valid = false
             return valid
         }
         
         valid = isValidEmail(email: email)
         
         return valid
     }
     
    class func isValidEmail(email:String) -> Bool {
         let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
         
         let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
         return emailTest.evaluate(with: email)
     }
    
    class func checkPassword(password: String) -> Bool {
        var valid = false;
        
        if (password.count < 6) {
            valid = false;
        }
        else {
            valid = true;
        }
        
        return valid
    }
}
