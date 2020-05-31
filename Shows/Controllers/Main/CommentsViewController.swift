//
//  CommentsViewController.swift
//  Shows
//
//  Created by mac on 31/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class CommentsViewController: BaseViewController {
    
    @IBOutlet weak var viewComments: UIView!
    @IBOutlet weak var viewNoComments: UIView!
    @IBOutlet weak var viewPostComment: UIView!
    @IBOutlet weak var tblComments: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }
    
    //MARK: - Custom Methods
    
    func registerCells() {
        self.tblComments.register(UINib(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell_ID")
    }

}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell_ID", for: indexPath) as? CommentTVCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    //MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
