//
//  CommentTVCell.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class CommentTVCell: UITableViewCell {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var viewDivider: UIView!
    
    @IBOutlet weak var constrHeightLblComment: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
