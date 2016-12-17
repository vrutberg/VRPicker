//
//  ViewController.swift
//  VRSlider
//
//  Created by Viktor Rutberg on 12/17/2016.
//  Copyright (c) 2016 Viktor Rutberg. All rights reserved.
//

import UIKit
import VRSlider

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 480, height: 640))
        
        view.addSubview(containerView)
        
        let config = VRSliderConfiguration(values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], defaultSelectedIndex: 1, itemWidth: 100, sliderHeight: 100, sliderWidth: 480)
        
        let sliderView = VRSlider(configuration: config)
        
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(sliderView)
        
        NSLayoutConstraint(item: sliderView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: sliderView, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: sliderView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: sliderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        view.layoutIfNeeded()
    }
}

