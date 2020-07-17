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
    
    @IBOutlet weak var constrTopImgLogo: NSLayoutConstraint!
    
    var rememberMe = false
    var shouldShowPassword = false
    
    var eventHandler: SLoginModuleInterface?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerKeyboardHandlers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.eventHandler?.interfaceWillAppear()
        enableLoginButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Custom Methods
    
    func setupUI() {
        btnLogin.layer.cornerRadius = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewEndEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func registerKeyboardHandlers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            constrTopImgLogo.constant -= (constrTopImgLogo.constant + 40)
        }
        else if UIDevice.current.screenType == .iPhones_6_6s_7_8  {
            constrTopImgLogo.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        constrTopImgLogo.constant = 68
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func viewEndEditing() {
        self.view.endEditing(true)
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
        
        self.eventHandler?.loginUser(rememberMe: self.rememberMe, email: email, password: password)
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

extension LoginViewController: SLoginUserInterface {
    
    func showLoading() {
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showErrorWithMesage(message: String) {
        
    }
    
    func setupCredentials(rememberMe: Bool, email: String, password: String) {
        self.rememberMe = rememberMe
        imgCheckRememberMe.image = rememberMe ? UIImage(named: "icon_checkbox_filled") : UIImage(named: "icon_checkbox_empty")
        
        txfEmail.text = email
        txfPassword.text = password
    }
    
    func showLoginSuccess() {
        let vc = NavigationManager.shared.instantiateShowsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
