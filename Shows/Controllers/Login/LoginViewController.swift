//
//  LoginViewController.swift
//  Shows
//
//  Created by mac on 30/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txfEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txfPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var imgCheckRememberMe: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    
    var rememberMe = false
    var shouldShowPassword = false
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCredentials()
        enableLoginButton()
    }
    
    // MARK: - Custom Methods
    
    func setupUI() {
        btnLogin.layer.cornerRadius = 5
    }
    
    func enableLoginButton() {
        guard let email = txfEmail.text, let password = txfPassword.text else {
            btnLogin.isEnabled = false
            btnLogin.alpha = 0.5
            
            return
        }
        
        guard UtilsCheck.checkEmail(email: email) && UtilsCheck.checkPassword(password: password) else {
            btnLogin.isEnabled = false
            btnLogin.alpha = 0.5
            
            return
        }
        
        btnLogin.isEnabled = true
        btnLogin.alpha = 1
    }
    
    func loadCredentials() {
        let shouldRememberMe = UserDefaults.standard.bool(forKey: Constants.k_RememberMe)
        
        rememberMe = shouldRememberMe
        imgCheckRememberMe.image = rememberMe ? UIImage(named: "icon_checkbox_filled") : UIImage(named: "icon_checkbox_empty")
        
        if rememberMe {
            guard let email = UserDefaults.standard.value(forKey: Constants.k_EmailUser) as? String  else {
                return
            }
            
            do {
                let passwordItem = KeychainManager(service: KeychainConfiguration.serviceName,
                                                        account: email,
                                                        accessGroup: KeychainConfiguration.accessGroup)
                
                let keychainPassword = try passwordItem.readPassword()
                
                txfEmail.text = email
                txfPassword.text = keychainPassword
                
            } catch {
                print("Error reading password from keychain - \(error)")
            }
        }
        else {
            txfEmail.text = ""
            txfPassword.text = ""
        }
    }
    
    //MARK: - IBActions Methods
    
    @IBAction func btnShowPassword(_ sender: UIButton) {
        shouldShowPassword = !shouldShowPassword
        
        txfPassword.isSecureTextEntry = shouldShowPassword ? false : true
        
        let image = shouldShowPassword ? UIImage(named: "icon_hide_password") : UIImage(named: "icon_show_password")
        sender.setImage(image, for: .normal)
    }
    
    @IBAction func btnRememberMe(_ sender: UIButton) {
        rememberMe = !rememberMe
        
        imgCheckRememberMe.image = rememberMe ? UIImage(named: "icon_checkbox_filled") : UIImage(named: "icon_checkbox_empty")
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        //>>    Save credentials
        UserDefaults.standard.set(rememberMe, forKey: Constants.k_RememberMe)
        
        let email = txfEmail.text!
        let password = txfPassword.text!
        
        SVProgressHUD.show()
        
        ShowServices.shared.getUser(email, password: password) { [weak self] succes in
            guard let self = self else { return }
            
            guard succes == true else {
                SVProgressHUD.dismiss()
                return 
            }
            
            if self.rememberMe {
                SVProgressHUD.dismiss()
                
                   UserDefaults.standard.set(email, forKey: Constants.k_EmailUser)
                   
                   do {
                       let passwordItem = KeychainManager(service: KeychainConfiguration.serviceName,
                                                          account: email,
                                                          accessGroup: KeychainConfiguration.accessGroup)
                       
                       try passwordItem.savePassword(password)
                   } catch {
                       print(error.localizedDescription)
                   }
               }
            
            let vc = NavigationManager.shared.instantiateShowsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfEmail {
            txfPassword.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString:NSString? = textField.text as NSString?
        let updatedString = nsString?.replacingCharacters(in:range, with:string);
        
        textField.text = updatedString;
        
        
        //Setting the cursor at the right place
        let selectedRange = NSMakeRange(range.location + string.count, 0)
        let from = textField.position(from: textField.beginningOfDocument, offset:selectedRange.location)
        let to = textField.position(from: from!, offset:selectedRange.length)
        textField.selectedTextRange = textField.textRange(from: from!, to: to!)
        
        //Sending an action
        textField.sendActions(for: UIControl.Event.editingChanged)
        
        //Update UI
        enableLoginButton()
        
        return false;
    }
    
    @IBAction func textFieldDidChange(_ sender: SkyFloatingLabelTextField) {
        if sender == txfEmail {
            if let text = txfEmail.text {
                if !UtilsCheck.checkEmail(email: text) {
                    txfEmail.errorMessage = "Please enter a valid email addres."
                }
                else  {
                    txfEmail.errorMessage = ""
                    txfEmail.title = "EMAIL"
                }
            }
        }
        else if sender == txfPassword {
            if let paasword = txfPassword.text {
                if !UtilsCheck.checkPassword(password: paasword) {
                    txfPassword.errorMessage = "Password should be at least 6 characters long."
                }
                else {
                    txfPassword.errorMessage = ""
                    txfPassword.title = "Password"
                }
            }
        }
    }
    
    
}
