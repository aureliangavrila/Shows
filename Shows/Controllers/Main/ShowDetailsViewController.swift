//
//  ShowDetailsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class ShowDetailsViewController: BaseViewController {
    
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var viewDividerShadow: UIView!
    @IBOutlet weak var lblShowName: UILabel!
    @IBOutlet weak var txtShowDescription: UITextView!
    @IBOutlet weak var lblCountEpisodes: UILabel!
    @IBOutlet weak var tblEpisodes: UITableView!
    
    // MARK: - StatusBar Methods
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    //MARK: - Custom Methods
    
    func registerCells() {
        self.tblEpisodes.register(UINib(nibName: "ShowDetailsTVCell", bundle: nil), forCellReuseIdentifier: "ShowDetailsTVCell_ID")
    }
    
    //MARK: - IBActions Methods
    
    @IBAction func btnBack(_ sender: UIButton) {
    }
    
    @IBAction func btnAddNewEpisode(_ sender: UIButton) {
    }
    
    
}

extension ShowDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetailsTVCell_ID", for: indexPath) as? ShowDetailsTVCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
