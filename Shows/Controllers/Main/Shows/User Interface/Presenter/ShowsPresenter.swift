//
//  ShowsPresenter.swift
//  Shows
//
//  Created by mac on 20/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation


class ShowsPresenter: SShowsModuleInterface {
    
    var userInterface: SShowsUserInterface?
    
    //MARK: - HELPERS Methods
    
    func clearKeychain() {
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
    
    //MARK: - API Methods
    
    func getShows() {
        userInterface?.showLoading()
        
        ShowService.shared.getShows {[weak self] (arrayShows, error) in
            guard let self = self else { return }
            
            self.userInterface?.hideLoading()
            
            guard error == nil else {
                self.userInterface?.showErrorWithMesage(message: error!.localizedDescription)
                
                return
            }
            
            self.userInterface?.setDataSource(shows: arrayShows!)
        }
    }
    
    //MARK: - Module Interface
    
    func interfaceDidLoad() {
        getShows()
    }
    
    func logoutButtonTapped() {
        clearKeychain()
        
        userInterface?.logoutPopViewController()
    }
}
