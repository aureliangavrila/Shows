//
//  ShowDetailsTVCell.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class ShowDetailsTVCell: UITableViewCell {
    
    @IBOutlet weak var lblSeasonEpidodeDetails: UILabel!
    @IBOutlet weak var lblEpisodeName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWith(_ episode: Episode) {
        lblEpisodeName.text = episode.title
        lblSeasonEpidodeDetails.text = "S\(episode.season) E\(episode.episodeNumber)"
    }
    
}
