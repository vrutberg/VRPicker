//
//  ViewController.swift
//  VRSlider
//
//  Created by Viktor Rutberg on 12/17/2016.
//  Copyright (c) 2016 Viktor Rutberg. All rights reserved.
//

import UIKit
import VRSlider

class ViewController: UIViewController, VRSliderDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let config = VRSliderConfiguration(items: (1...10).map { return "\($0) år" })
        
        let sliderView = VRSlider(with: config, frame: .zero)

        sliderView.backgroundColor = .white
        sliderView.delegate = self
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sliderView)
        
        NSLayoutConstraint(item: sliderView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: sliderView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: sliderView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: sliderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        
        view.layoutIfNeeded()
    }
    
    func slider(_ sender: VRSlider, didSelectIndex index: Int) {
        print("didSelectIndex: \(index)")
    }
}

