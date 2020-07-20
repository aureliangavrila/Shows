//
//  SShowsUserInterface.swift
//  Shows
//
//  Created by mac on 20/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

protocol SShowsUserInterface {
    
    func showLoading()
    func hideLoading()
    func showErrorWithMesage(message: String)
    
    func setDataSource(shows: [Show])
    func logoutPopViewController()
}
