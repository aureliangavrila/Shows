//
//  SLoginUserInterface.swift
//  Shows
//
//  Created by mac on 15/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

protocol SLoginUserInterface {
    
    func showLoading()
    func hideLoading()
    func showErrorWithMesage(message: String)
    func showLoginSuccess()
    
    func setupCredentials(rememberMe: Bool, email: String, password: String)
}
