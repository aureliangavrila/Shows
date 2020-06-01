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
    
    var currEpisode: Episode!
    
    // MARK: - StatusBar Methods
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI(episode: currEpisode)
    }
    
    //MARK: - Custom Methods
    
    func updateUI(episode: Episode) {
        lblEpisodeName.text = episode.title
        lblSeasonEpisode.text = "S\(episode.season) E\(episode.episodeNumber)"
        lblEpisodeDescription.text = episode.description
        
        imgEpisode.kf.setImage(with:  URL(string: "https://api.infinum.academy" + episode.imageUrl)!)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnComments(_ sender: UIButton) {
        let vc = NavigationManager.shared.instantiateCommentsViewController()
        vc.currEpisode = currEpisode
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
