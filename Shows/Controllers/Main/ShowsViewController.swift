//
//  ShowsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var tblShows: UITableView!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Custom Methods
    
    func clearKeychain() {
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
    
    //MARK: - IBAction Methods
    
    @IBAction func btnLogout(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        clearKeychain()
    }
    

}

extension ShowsViewController: UITableViewDataSource {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShowTVCell_ID", for: indexPath) as? ShowTVCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
