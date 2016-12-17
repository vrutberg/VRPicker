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

    @IBOutlet weak var sliderView: VRSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("setting slider configuration")
        
        sliderView.configuration = VRSliderConfiguration(values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], defaultSelectedIndex: 1, itemWidth: 100, sliderHeight: 100, sliderWidth: 414)
        
        sliderView.delegate = self
        
    }
    
    func slider(_ sender: VRSlider, didSelectIndex index: Int) {
        print("didSelectIndex: \(index)")
    }
}

