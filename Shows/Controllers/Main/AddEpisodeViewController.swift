//
//  AddEpisodeViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Photos

class AddEpisodeViewController: BaseViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var btnUploadPhoto: UIButton!
    @IBOutlet weak var txfEpisodTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var txfSeasonEpisod: SkyFloatingLabelTextField!
    @IBOutlet weak var txfDescription: SkyFloatingLabelTextField!
    @IBOutlet weak var viewUploadPhoto: UIView!
    
    @IBOutlet weak var constrHeightViewUploadPhoto: NSLayoutConstraint!
    @IBOutlet weak var constrBottomViewUploadPhoto: NSLayoutConstraint!
    
    let imagePickerController = UIImagePickerController()
    
    var selectedImage: UIImage?
    var showId: String!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Custom Methods
    
    func setupUI() {
        btnUploadPhoto.imageView?.contentMode = .scaleAspectFill
        btnUploadPhoto.layer.cornerRadius = btnUploadPhoto.frame.height / 2
        btnUploadPhoto.layer.masksToBounds = true
        btnUploadPhoto.clipsToBounds = true
        
        imagePickerController.delegate = self
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
        
        ShowServices.shared.addEpisode(image, showId: self.showId, title: title, season: value.0, episode: value.1, description: description)
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
}
