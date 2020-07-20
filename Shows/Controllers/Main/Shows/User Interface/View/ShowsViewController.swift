//
//  ShowsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var tblShows: UITableView!
    
    var arrShows = [Show]()
    
    var eventHandler: SShowsModuleInterface?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventHandler?.interfaceDidLoad()
        registerCells()
    }
    
    //MARK: - Custom Methods
    
    func registerCells() {
         self.tblShows.register(UINib(nibName: "ShowTVCell", bundle: nil), forCellReuseIdentifier: "ShowTVCell_ID")
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnLogout(_ sender: UIButton) {
        eventHandler?.logoutButtonTapped()
    }
    
    
}

extension ShowsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTVCell_ID", for: indexPath) as? ShowTVCell else {
            return UITableViewCell()
        }
        
        cell.configureCellWith(arrShows[indexPath.row])
        
        return cell
    }
    
    //MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = NavigationManager.shared.instantiateShowDetailsViewController()
        vc.currShow = self.arrShows[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShowsViewController: SShowsUserInterface {
    
    func showLoading() {
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showErrorWithMesage(message: String) {
        let alert = UtilsDisplay.okAlert(name: "Error", message: message)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setDataSource(shows: [Show]) {
        self.arrShows = shows
        self.tblShows.reloadData()
    }
    
    func logoutPopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
