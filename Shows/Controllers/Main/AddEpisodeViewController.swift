//
//  AddEpisodeViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddEpisodeViewController: BaseViewController {
    
    @IBOutlet weak var btnUploadPhoto: UIButton!
    @IBOutlet weak var txfEpisodTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var txfSeasonEpisod: SkyFloatingLabelTextField!
    @IBOutlet weak var txfDescription: SkyFloatingLabelTextField!
    @IBOutlet weak var viewUploadPhoto: UIView!
    
    @IBOutlet weak var constrHeightViewUploadPhoto: NSLayoutConstraint!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnCancel(_ sender: UIButton) {
    }
    
    @IBAction func btnAdd(_ sender: UIButton) {
    }
    
    @IBAction func btnTakePhoto(_ sender: UIButton) {
    }
    
    @IBAction func btnSelectPhoto(_ sender: UIButton) {
    }
    
    @IBAction func btnDismissView(_ sender: UIButton) {
    }
    
    @IBAction func btnUploadPhoto(_ sender: UIButton) {
    }
    
    
}
