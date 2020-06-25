//
//  ShowTVCell.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class ShowTVCell: UITableViewCell {
    
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var lblNameShow: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellWith(_ show: Show) {
        lblNameShow.text = show.title
        
        guard let url = URL(string: Constants.baseURL + show.imageUrl) else {
            return
        }
        
        imgShow.kf.setImage(with: url)
    }
    
}
