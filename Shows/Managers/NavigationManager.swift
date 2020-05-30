//
//  NavigationManager.swift
//  Shows
//
//  Created by mac on 30/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {
    static let shared = NavigationManager()
    
    //MARK: - LOGIN
    
    func instantiateLoginViewController() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        return controller
    }
    
    //MARK: - MAIN
    
    
}
