//
//  ShowDetailsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import SVProgressHUD
import SVPullToRefresh

class ShowDetailsViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var viewDividerShadow: UIView!
    @IBOutlet weak var lblShowName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCountEpisodes: UILabel!
    @IBOutlet weak var tblEpisodes: UITableView!
    
    @IBOutlet weak var constrHeighTxtDescription: NSLayoutConstraint!
    
    var currShow: Show!
    var arrEpisodes = [Episode]()
    
    // MARK: - StatusBar Methods
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateUI(show: self.currShow)
        registerCells()
        getShowInfo()
        getShowEpisodes()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 10)
    }
    
    //MARK: - Custom Methods
    
    func setupUI() {
        scrollView.delegate = self
        
        scrollView.addPullToRefresh {
            self.scrollView.pullToRefreshView.arrowColor = .white
            self.getShowEpisodes()
        }
    
    }
    
    func updateUI(show: Show) {
        lblShowName.text = show.title
        imgShow.kf.setImage(with: URL(string: Constants.baseURL + show.imageUrl)!)
        
        let description = show.description ?? ""
        lblDescription.text = description
        
        let height = description.stringHeight(limit: self.lblDescription.frame.width , and: self.lblDescription.font)
        
        if height <= 90 {
            constrHeighTxtDescription.constant = height
        }
        else {
            constrHeighTxtDescription.constant = 90
        }
    }
    
    func registerCells() {
        
        self.tblEpisodes.register(UINib(nibName: "ShowDetailsTVCell", bundle: nil), forCellReuseIdentifier: "ShowDetailsTVCell_ID")
    }
    
    //MARK: - API Methods
    
    func getShowInfo() {
        ShowServices.shared.getShowInfo(currShow) {[weak self] (show, error) in
            guard let self = self else { return }
            
            guard error == nil else {
                let alert = UtilsDisplay.okAlert(name: "Error", message: error!.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            self.currShow = show!
            self.updateUI(show: self.currShow)
        }
    }
    
    func getShowEpisodes() {
        SVProgressHUD.show()
        
        ShowServices.shared.getShowEpisodes(currShow) {[weak self] (arrEpisodes, error) in
            guard let self = self else { return }
            
            SVProgressHUD.dismiss()
            
            self.scrollView.pullToRefreshView.stopAnimating()
            
            guard error == nil else {
                let alert = UtilsDisplay.okAlert(name: "Error", message: error!.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                
                self.lblCountEpisodes.text = "0"
                self.tblEpisodes.isHidden = true
                
                return
            }
            
            guard let episodes = arrEpisodes else {
                self.lblCountEpisodes.text = "0"
                self.tblEpisodes.isHidden = true
                return
            }
            
            self.lblCountEpisodes.text = "\(episodes.count)"
            self.arrEpisodes = episodes
            self.tblEpisodes.reloadData()
        }
    }
    
    //MARK: - IBActions Methods
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNewEpisode(_ sender: UIButton) {
        let vc = NavigationManager.shared.instantiateAddEpisodeViewController()
        vc.showId = currShow.id
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ShowDetailsViewController: UITableViewDataSource, UITableViewDelegate, AddNewEpisodeDelegate, UIScrollViewDelegate {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetailsTVCell_ID", for: indexPath) as? ShowDetailsTVCell else {
            return UITableViewCell()
        }
        
        let episode = arrEpisodes[indexPath.row]
        cell.lblEpisodeName.text = episode.title
        cell.lblSeasonEpidodeDetails.text = "S\(episode.season) E\(episode.episodeNumber)"
        
        return cell
    }
    
    //MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NavigationManager.shared.instantiateEpisodeDetailsViewController()
        vc.currEpisode = arrEpisodes[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - UIScrollViewDelegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    //MARK: - AddNewEpisodeDelegate Methods
    
    func newEpisodeCreated() {
        self.getShowEpisodes()
    }
}
