//
//  UIView+Extension.swift
//  VRPicker
//
//  Created by Viktor Rutberg on 2018-06-09.
//

import Foundation

extension UIView {
    func matchSize(with otherView: UIView) {
        NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: otherView.topAnchor),
                bottomAnchor.constraint(equalTo: otherView.bottomAnchor),
                leadingAnchor.constraint(equalTo: otherView.leadingAnchor),
                trailingAnchor.constraint(equalTo: otherView.trailingAnchor)
            ])
    }
}
