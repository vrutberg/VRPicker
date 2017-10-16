//
//  PickerItemCollectionViewCell.swift
//  VRPicker
//
//  Created by Viktor Rutberg on 2017-10-16.
//

import Foundation

class PickerItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!

    func update(string: String) {
        label.text = string
    }
}
