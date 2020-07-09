//
//  LoginViewModel.swift
//  Shows
//
//  Created by mac on 08/07/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

public final class LoginViewModel {
    
    let credentials: Binder<(String?, String?)> = Binder((nil, nil))
    let shouldRememberMe = Binder(false)
    let loginRequestResult = Binder(false)
    
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
        loadCredentials()
    }
    
   private func loadCredentials() {
        let rememberMe = UserDefaults.standard.bool(forKey: Constants.k_RememberMe)
        shouldRememberMe.value = rememberMe
        
        if rememberMe {
            guard let email = UserDefaults.standard.value(forKey: Constants.k_EmailUser) as? String  else {
                credentials.value = (nil, nil)
                return
            }
            
            do {
                let passwordItem = KeychainManager(service: KeychainConfiguration.serviceName,
                                                   account: email,
                                                   accessGroup: KeychainConfiguration.accessGroup)
                
                let keychainPassword = try passwordItem.readPassword()
                
                credentials.value = (email, keychainPassword)
            } catch {
                credentials.value = (nil, nil)
                
                print("Error reading password from keychain - \(error)")
            }
        }
        else {
            credentials.value = ("", "")
        }
    }
    
    func requestLogin(_ email: String, password: String) {
        self.isLoading = true
        
        ShowServices.shared.getUser(email, password: password) {[weak self] (succes, error) in
            guard let self = self else { return }
            
            self.isLoading = false
            
            guard error == nil else {
                self.error = error
                
                return
            }
            
            self.loginRequestResult.value = succes
        }
    }
    
}
