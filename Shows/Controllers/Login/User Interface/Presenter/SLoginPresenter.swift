//
//  SLoginPresenter.swift
//  Shows
//
//  Created by mac on 15/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

protocol SLoginPresenterModuleInterface {
    func getUser(_ email: String, password: String, completion: @escaping (_ succes: Bool, _ error: Error?) -> Void)
}

class SLoginPresenter: SLoginModuleInterface, SLoginServiceDelegate {
    
    var userInterface: SLoginUserInterface?
    var interactor: SLoginPresenterModuleInterface?
    
    var rememberMe = false
    
    //MARK: - Helpers Methods
    
    func loadCredentials() {
        let shouldRememberMe = UserDefaults.standard.bool(forKey: Constants.k_RememberMe)
        
        if shouldRememberMe {
            guard let email = UserDefaults.standard.value(forKey: Constants.k_EmailUser) as? String  else {
                return
            }
            
            do {
                let passwordItem = KeychainManager(service: KeychainConfiguration.serviceName,
                                                   account: email,
                                                   accessGroup: KeychainConfiguration.accessGroup)
                
                let keychainPassword = try passwordItem.readPassword()
                
                self.userInterface?.setupCredentials(rememberMe: shouldRememberMe, email: email, password: keychainPassword)
            } catch {
                #if DEBUG
                print("Error reading password from keychain - \(error)")
                #endif
            }
        }
        else {
            self.userInterface?.setupCredentials(rememberMe: shouldRememberMe, email: "", password: "")
        }
    }
    
    //MARK: - Module Interface Methods
    
    func interfaceWillAppear() {
        self.loadCredentials()
    }
    
    func loginUser(rememberMe: Bool, email: String, password: String) {
        self.rememberMe = rememberMe
        
        self.userInterface?.showLoading()
    
        self.interactor?.getUser(email, password: password, completion: {(success, error) in
         self.userInterface?.hideLoading()
            
            guard error == nil else {
                return
            }
            
            if rememberMe {
                UserDefaults.standard.set(email, forKey: Constants.k_EmailUser)
                
                do {
                    let passwordItem = KeychainManager(service: KeychainConfiguration.serviceName,
                                                       account: email,
                                                       accessGroup: KeychainConfiguration.accessGroup)
                    
                    try passwordItem.savePassword(password)
                } catch {
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            }
        })
    }
    
    //MARK: Interactor Methods
    
    func showSuccesLoginUser(success: Bool) {
        guard success == true else {
            return
        }
        
        self.userInterface?.showLoginSuccess()
    }
    
    func showError(error: SError) {
        self.userInterface?.showErrorWithMesage(message: error.localizedDescription)
    }
    
}
