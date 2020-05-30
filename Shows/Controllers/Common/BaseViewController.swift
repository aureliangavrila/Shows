//
//  BaseViewController.swift
//  Shows
//
//  Created by mac on 30/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - StatusBar Methods
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        print("\(className) deinit")
    }
    
    
}
