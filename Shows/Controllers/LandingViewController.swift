//
//  ViewController.swift
//  Shows
//
//  Created by mac on 30/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class LandingViewContoller: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = NavigationManager.shared.instantiateLoginViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

