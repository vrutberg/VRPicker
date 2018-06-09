//
//  PickerItemCollectionViewCell.swift
//  VRPicker
//
//  Created by Viktor Rutberg on 2017-10-16.
//

import Foundation

class PickerItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!

    func update(model: Model) {
        label.text = model.text
        label.font = model.font
        label.textColor = model.fontColor
    }

    struct Model {
        let text: String
        let font: UIFont
        let fontColor: UIColor
    }
}
