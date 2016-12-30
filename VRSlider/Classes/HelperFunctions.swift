//
//  HelperFunctions.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-30.
//
//

import Foundation
import UIKit

internal func matchSizeWithConstraints(view1: UIView, view2: UIView) {
    NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1, constant: 0).isActive = true

    NSLayoutConstraint(item: view1, attribute: .leading, relatedBy: .equal, toItem: view2, attribute: .leading, multiplier: 1, constant: 0).isActive = true

    NSLayoutConstraint(item: view1, attribute: .trailing, relatedBy: .equal, toItem: view2, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

    NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
}
