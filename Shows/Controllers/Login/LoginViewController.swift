//
//  LoginViewController.swift
//  Shows
//
//  Created by mac on 30/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

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
    
    // MARK: - Custom Methods
    
    func setupUI() {
        btnLogin.layer.cornerRadius = 5
    }
    
    func updateUI() {
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
        updateUI()
        
        return false;
    }
    
}
