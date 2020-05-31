//
//  EpisodeDetailsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: BaseViewController {
    
    @IBOutlet weak var imgEpisode: UIImageView!
    @IBOutlet weak var lblEpisodeName: UILabel!
    @IBOutlet weak var lblSeasonEpisode: UILabel!
    @IBOutlet weak var lblEpisodeDescription: UILabel!
    
    @IBOutlet weak var constrHeightLblDescription: NSLayoutConstraint!
    
    // MARK: - StatusBar Methods
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Custom Methods
    
    //MARK: - IBAction Methods
    
    @IBAction func btnBack(_ sender: UIButton) {
    }
    
    @IBAction func btnComments(_ sender: UIButton) {
    }
    
}
