//
//  ShowDetailsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var viewDividerShadow: UIView!
    @IBOutlet weak var lblShowName: UILabel!
    @IBOutlet weak var txtShowDescription: UITextView!
    @IBOutlet weak var lblCountEpisodes: UILabel!
    @IBOutlet weak var tblEpisodes: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
    }
    
    @IBAction func btnAddNewEpisode(_ sender: UIButton) {
    }
    

}
