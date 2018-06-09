//
//  ViewController.swift
//  VRPicker
//
//  Created by Viktor Rutberg on 12/17/2016.
//  Copyright (c) 2016 Viktor Rutberg. All rights reserved.
//

import UIKit
import VRPicker

struct PickerItem: VRPickerItem {
    let number: Int

    var description: String {
        return "\(number) yrs"
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let config = VRPickerConfiguration<PickerItem>(items: (1...100).map { PickerItem(number: $0) },
                                                       defaultSelectedIndex: 99,
                                                       selectionRadiusInPercent: 0.5,
                                                       itemWidth: 80)

        let pickerView = VRPicker<PickerItem>(with: config, frame: .zero)

        pickerView.backgroundColor = .white
        pickerView.didSelectItem = self.pickerDidSelect
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pickerView)

        let layoutMargins = view.layoutMarginsGuide

        NSLayoutConstraint.activate([pickerView.topAnchor.constraint(equalTo: layoutMargins.topAnchor),
                                     pickerView.leadingAnchor.constraint(equalTo: layoutMargins.leadingAnchor),
                                     pickerView.trailingAnchor.constraint(equalTo: layoutMargins.trailingAnchor),
                                     pickerView.heightAnchor.constraint(equalToConstant: 80)])
    }

    func pickerDidSelect(_ item: PickerItem) {
        print("didSelectItem: \(item)")
    }
}
