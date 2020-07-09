//
//  ShowsViewModel.swift
//  Shows
//
//  Created by mac on 09/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

public final class ShowsViewModel {
    
    init() {
    }
    
    
    func logoutTapped() {
        clearKeychain()
    }
    
    private func clearKeychain() {
        UserDefaults.standard.set(false, forKey: Constants.k_RememberMe)
        UserDefaults.standard.removeObject(forKey: Constants.k_EmailUser)
        
        do {
            let passwordItems = try KeychainManager.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
            for passwordItem in passwordItems {
                
                do {
                    try passwordItem.deleteItem()
                }catch {
                    fatalError("Error deleting from keychain - \(error)")
                }
            }
        } catch {
            fatalError("Error reading from keychain - \(error)")
        }
    }
    
    
}
