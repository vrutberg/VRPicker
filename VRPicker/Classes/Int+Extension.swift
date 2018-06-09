//
//  Int+Extension.swift
//  VRPicker
//
//  Created by Viktor Rutberg on 2018-06-09.
//

import Foundation

extension Int {
    func bound(minVal: Int, maxVal: Int) -> Int {
        return Swift.max(Swift.min(self, maxVal), minVal)
    }
}
