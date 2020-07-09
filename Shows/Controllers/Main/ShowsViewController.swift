//
//  ShowsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import Kingfisher

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var tblShows: UITableView!
    
    var arrShows = [Show]()
    
    let viewModel = ShowsViewModel()
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getShows()
    }
    
    //MARK: - Custom Methods
    
    func setupUI() {
        self.tblShows.register(UINib(nibName: "ShowTVCell", bundle: nil), forCellReuseIdentifier: "ShowTVCell_ID")
    }
    
    func clearKeychain() {
        UserDefaults.standard.set(false, forKey: Constants.k_RememberMe)
        UserDefaults.standard.removeObject(forKey: Constants.k_EmailUser)
        
        do {
            let passwordItems = try KeychainManager.passwordItems(forService: KeychainConfiguration.serviceName, accessGroup: KeychainConfiguration.accessGroup)
            for passwordItem in passwordItems {
                
                do {
                    try passwordItem.deleteItem()
                }catch {
                    fatalError("Error deleting from keychain - \(error)")
                }
            }
        } catch {
            fatalError("Error reading from keychain - \(error)")
        }
    }
    
    //MARK: - API Methods
    
    func getShows() {
        ShowServices.shared.getShows {[weak self] (arrayShows, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                guard error == nil else {
                    let alert = UtilsDisplay.okAlert(name: "Error", message: error!.localizedDescription)
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                self.arrShows = arrayShows!
                self.tblShows.reloadData()
            }
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnLogout(_ sender: UIButton) {
//        clearKeychain()
        viewModel.logoutTapped()
        
        self.navigationController?.popViewController(animated: true)
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
        
        let show = arrShows[indexPath.row]
        
        cell.lblNameShow.text = show.title
        cell.imgShow.kf.setImage(with: URL(string: Constants.baseURL + show.imageUrl)!)
        
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
