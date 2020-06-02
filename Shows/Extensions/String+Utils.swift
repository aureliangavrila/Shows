//
//  String+Utils.swift
//  Shows
//
//  Created by mac on 02/06/2020.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit


extension String {

    func stringHeight(limit: CGFloat, and font: UIFont) -> CGFloat {
        return (self as NSString).boundingRect(with: CGSize(width: limit, height: CGFloat.infinity),
                                               options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                               attributes: [NSAttributedString.Key.font: font],
                                               context: nil).height
    }
}
