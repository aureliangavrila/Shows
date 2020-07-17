//
//  SLoginModuleInterface.swift
//  Shows
//
//  Created by mac on 15/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

protocol SLoginModuleInterface {
    func interfaceWillAppear()
    
    func loginUser(rememberMe: Bool, email: String, password: String)
}
