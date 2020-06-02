//
//  AddEpisodeViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SVProgressHUD

protocol AddNewEpisodeDelegate {
    func newEpisodeCreated()
}

class AddEpisodeViewController: BaseViewController {
    
    @IBOutlet weak var btnUploadPhoto: UIButton!
    @IBOutlet weak var txfEpisodTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var txfSeasonEpisod: SkyFloatingLabelTextField!
    @IBOutlet weak var txfDescription: SkyFloatingLabelTextField!
    @IBOutlet weak var viewUploadPhoto: UIView!
    
    @IBOutlet weak var constrHeightViewUploadPhoto: NSLayoutConstraint!
    @IBOutlet weak var constrBottomViewUploadPhoto: NSLayoutConstraint!
    @IBOutlet weak var constrTopBtnUploadPhoto: NSLayoutConstraint!
    
    let imagePickerController = UIImagePickerController()
    
    var selectedImage: UIImage?
    var showId: String!
    
    var delegate: AddNewEpisodeDelegate?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Custom Methods
    
    func setupUI() {
        btnUploadPhoto.imageView?.contentMode = .scaleAspectFill
        btnUploadPhoto.layer.cornerRadius = btnUploadPhoto.frame.height / 2
        btnUploadPhoto.layer.masksToBounds = true
        btnUploadPhoto.clipsToBounds = true
        
        imagePickerController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewEndEditing))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewEndEditing() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            constrTopBtnUploadPhoto.constant -= (constrTopBtnUploadPhoto.constant + btnUploadPhoto.frame.height / 2)
        }
        else if UIDevice.current.screenType == .iPhones_6_6s_7_8  {
            constrTopBtnUploadPhoto.constant = 0
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        constrTopBtnUploadPhoto.constant = 33
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideChoosePhotoView() {
        constrBottomViewUploadPhoto.constant = 247
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
        guard let image = self.selectedImage else {
            let alert = UtilsDisplay.okAlert(name: "Oops", message: "Please select a photo to upload.")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let title = txfEpisodTitle.text, title != "" else {
            let alert = UtilsDisplay.okAlert(name: "Oops", message: "The episode title cannot be empty.")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let seasonEpisode = txfSeasonEpisod.text, seasonEpisode != "" else {
            let alert = UtilsDisplay.okAlert(name: "Oops", message: "Season and Episode cannot be empty.")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let value = UtilsCheck.checkFormatSeasonAndEpisode(text: seasonEpisode) else {
            let alert = UtilsDisplay.okAlert(name: "Oops", message: "Season and Episode format is not correct")
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let description = txfDescription.text ?? ""
        
        SVProgressHUD.show()
        
        ShowServices.shared.addEpisode(image, showId: self.showId, title: title, season: value.0, episode: value.1, description: description) {[weak self] (success, error) in
            guard let self = self else { return }
            
            SVProgressHUD.dismiss()
            
            guard error == nil else {
                let alert = UtilsDisplay.okAlert(name: "Error", message: error!.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                
                return 
            }
            
            guard success == true else {
                return
            }
            
            self.delegate?.newEpisodeCreated()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnUploadPhoto(_ sender: UIButton) {
        constrBottomViewUploadPhoto.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnTakePhoto(_ sender: UIButton) {
        hideChoosePhotoView()
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .camera
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnSelectPhoto(_ sender: UIButton) {
        hideChoosePhotoView()
        
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnDismissView(_ sender: UIButton) {
        hideChoosePhotoView()
    }
    

}

extension AddEpisodeViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    //MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        selectedImage = image
        btnUploadPhoto.setImage(image, for: .normal)
        btnUploadPhoto.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfEpisodTitle {
            txfSeasonEpisod.becomeFirstResponder()
        }
        else if textField == txfSeasonEpisod {
            txfDescription.becomeFirstResponder()
        }
        else if  textField == txfDescription {
            txfDescription.resignFirstResponder()
        }
        
        return true
    }
    
    
}
