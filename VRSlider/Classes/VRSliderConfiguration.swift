//
//  VRSliderConfiguration.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-17.
//
//

import Foundation

public struct VRSliderConfiguration {
    let values: [Int]
    let defaultSelectedIndex: Int
    
    let selectedFont: UIFont
    let nonSelectedFont: UIFont
    
    let gradientColors: [UIColor]
    let gradientWidthInPercent: Double
    
    let sliderHeight: Int
    let sliderWidth: Int
    let itemWidth: Int
    
    public init(values: [Int] = [1, 2, 3, 4, 5],
                defaultSelectedIndex: Int = 0,
                selectedFont: UIFont = UIFont.boldSystemFont(ofSize: 16),
                nonSelectedFont: UIFont = UIFont.systemFont(ofSize: 14),
                
                gradientColors: [UIColor] = [.lightGray, .white],
                gradientWidthInPercent: Double = 0.4,
                
                itemWidth: Int = 100,
                sliderHeight: Int = 100,
                sliderWidth: Int = 414) {
        self.values = values
        self.defaultSelectedIndex = defaultSelectedIndex
        
        self.selectedFont = selectedFont
        self.nonSelectedFont = nonSelectedFont
        
        self.gradientColors = gradientColors
        self.gradientWidthInPercent = gradientWidthInPercent
        
        self.sliderHeight = sliderHeight
        self.sliderWidth = sliderWidth
        self.itemWidth = itemWidth
    }
}
