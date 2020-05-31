//
//  EpisodeDetailsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgEpisode: UIImageView!
    @IBOutlet weak var lblEpisodeName: UILabel!
    @IBOutlet weak var lblSeasonEpisode: UILabel!
    @IBOutlet weak var lblEpisodeDescription: UILabel!
    
    @IBOutlet weak var constrHeightLblDescription: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
    }
    
    @IBAction func btnComments(_ sender: UIButton) {
    }
    
}
