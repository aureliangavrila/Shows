//
//  ShowsViewModel.swift
//  Shows
//
//  Created by mac on 09/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

public final class ShowsViewModel {
    
    let shows:Binder<[Show]?> = Binder([])
    
    var error: Error? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingClosure?()
        }
    }
    
    var showAlertClosure: (() -> Void)?
    var updateLoadingClosure: (() -> Void)?
    
    init() {
        getShows()
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
    
    func getShows() {
        isLoading = true
        
        ShowServices.shared.getShows {[weak self] (arrayShows, error) in
            guard let self = self else { return }
            
            self.isLoading = false
            
            DispatchQueue.main.async {
                guard error == nil else {
                    self.error = error
                    
                    return
                }
                
                self.shows.value = arrayShows
            }
        }
    }
}
