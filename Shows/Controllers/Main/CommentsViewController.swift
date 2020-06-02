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
    @IBOutlet weak var txfComment: UITextField!
    
    @IBOutlet weak var constrHeightViewNewComm: NSLayoutConstraint!
    @IBOutlet weak var constrBottomViewComm: NSLayoutConstraint!
    
    var currEpisode: Episode!
    var arrComments = [Comment]()
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        registerCells()
        getCommentsForEpisode()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Custom Methods
    
    func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        
        imgUser.layer.cornerRadius = imgUser.frame.height / 2
        
        txfComment.layer.cornerRadius = txfComment.frame.height / 2
        txfComment.layer.borderWidth = 1
        txfComment.delegate = self
        txfComment.layer.borderColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1).cgColor
        txfComment.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        txfComment.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        txfComment.leftViewMode = .always
        txfComment.rightViewMode = .always
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func registerCells() {
        self.tblComments.register(UINib(nibName: "CommentTVCell", bundle: nil), forCellReuseIdentifier: "CommentTVCell_ID")
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        var safeAreaHeight = 0
        if #available(iOS 11.0, *) {
            safeAreaHeight = Int(view.safeAreaInsets.bottom)
        }
        
        constrBottomViewComm.constant -= (keyboardSize.height - CGFloat(safeAreaHeight))
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { finished in
            if finished {
                
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        constrBottomViewComm.constant = 0
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPostComment(_ sender: UIButton) {
        self.view.endEditing(true)
        
        guard let comment = txfComment.text else {
            return
        }
        
        postComment(comment)
    }
    
    //MARK: - API Methods
    
    func getCommentsForEpisode() {
        ShowServices.shared.getCommetnsForEpisode(currEpisode) {[weak self] (comments, error) in
             guard let self = self else { return }
            
            guard error == nil else {
                self.viewNoComments.isHidden = false
                return
            }
            
            guard let arrayComments = comments, arrayComments.count > 0 else {
                self.viewNoComments.isHidden = false
                return
            }
            
            self.arrComments = arrayComments
            self.tblComments.reloadData()
            self.viewNoComments.isHidden = true
        }
    }
    
    func postComment(_ comment: String) {
        ShowServices.shared.postCommentForEpisode(currEpisode, cooment: comment) {[weak self] (comment, error) in
            guard let self = self else { return }
            
            self.txfComment.text = ""
            self.arrComments.insert(comment!, at: 0)
            self.tblComments.beginUpdates()
            self.tblComments.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
            self.tblComments.endUpdates()
        }
    }
    

}

extension CommentsViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTVCell_ID", for: indexPath) as? CommentTVCell else {
            return UITableViewCell()
        }
        
        let comment = arrComments[indexPath.row]
        cell.lblComment.text = comment.text
        cell.lblUserName.text = comment.userEmail
        
        if indexPath.row % 3 == 0 {
            cell.imgUser.image = #imageLiteral(resourceName: "img-user1")
        }
        else if indexPath.row % 2 == 0 {
            cell.imgUser.image = #imageLiteral(resourceName: "img-user2")
        }
        else {
            cell.imgUser.image = #imageLiteral(resourceName: "img-user3")
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
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
