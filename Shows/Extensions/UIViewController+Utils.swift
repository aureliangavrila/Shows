//
//  UIViewController+Utils.swift
//  Shows
//
//  Created by mac on 30/05/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}
