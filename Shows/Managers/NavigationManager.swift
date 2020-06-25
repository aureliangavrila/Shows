//
//  NavigationManager.swift
//  Shows
//
//  Created by mac on 30/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {
    static let shared = NavigationManager()
    
    //MARK: - LOGIN
    
    func instantiateLoginViewController() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as! LoginViewController
        
        return controller
    }
    
    //MARK: - MAIN
    
    func instantiateShowsViewController() -> ShowsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: ShowsViewController.self)) as! ShowsViewController
        
        return controller
    }
    
    func instantiateShowDetailsViewController() -> ShowDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: ShowDetailsViewController.self)) as! ShowDetailsViewController
        
        return controller
    }
    
    func instantiateEpisodeDetailsViewController() -> EpisodeDetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EpisodeDetailsViewController") as! EpisodeDetailsViewController
        
        return controller
    }
    
    func instantiateAddEpisodeViewController() -> AddEpisodeViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddEpisodeViewController") as! AddEpisodeViewController
        
        return controller
    }
    
    func instantiateCommentsViewController() -> CommentsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        
        return controller
    }
    
    
}
