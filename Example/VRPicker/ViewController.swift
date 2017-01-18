//
//  ViewController.swift
//  VRPicker
//
//  Created by Viktor Rutberg on 12/17/2016.
//  Copyright (c) 2016 Viktor Rutberg. All rights reserved.
//

import UIKit
import VRPicker

class ViewController: UIViewController, VRPickerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let config = VRPickerConfiguration(items: (1...10).map { return "\($0)" }, selectionRadiusInPercent: 0.5, itemWidth: 50)
        
        let pickerView = VRPicker(with: config, frame: .zero)

        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pickerView)
        
        NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .top, multiplier: 1, constant: 20).isActive = true
        
        NSLayoutConstraint(item: pickerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: pickerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: pickerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
        
        view.layoutIfNeeded()
    }
    
    func picker(_ sender: VRPicker, didSelectIndex index: Int) {
        print("didSelectIndex: \(index)")
    }
}

