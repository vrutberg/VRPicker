//
//  UITapGestureRecognizer+Extension.swift
//  VRPicker
//
//  Created by Viktor Rutberg on 2018-06-09.
//

import Foundation

extension UITapGestureRecognizer {
    static var singleTap: UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer()

        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.isEnabled = true
        gestureRecognizer.cancelsTouchesInView = false

        return gestureRecognizer
    }
}
