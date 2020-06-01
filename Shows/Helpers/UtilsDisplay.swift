//
//  UtilsDisplay.swift
//  Shows
//
//  Created by mac on 01/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

open class UtilsDisplay {
    
    class func okAlert(name: String?, message: String)  -> UIAlertController {
           let alert = UIAlertController(title: name, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           
           return alert
    }
}
