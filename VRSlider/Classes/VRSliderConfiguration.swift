//
//  VRSliderConfiguration.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-17.
//
//

import Foundation

public enum GradientPosition {
    case above
    case below
}

public struct VRSliderConfiguration {
    let values: [String]
    let defaultSelectedIndex: Int
    
    let selectedFont: UIFont
    let selectedColor: UIColor
    let nonSelectedFont: UIFont
    let nonSelectedColor: UIColor
    let selectionBackgroundColor: UIColor
    
    let gradientColors: [UIColor]
    let gradientWidthInPercent: Double
    let gradientPosition: GradientPosition
    
    let itemWidth: Int
    
    public init(values: [String] = ["1 år", "2 år", "3 år", "4 år", "5 år"],
                defaultSelectedIndex: Int = 0,

                selectedFont: UIFont = UIFont.boldSystemFont(ofSize: 16),
                selectedColor: UIColor = .white,
                nonSelectedFont: UIFont = UIFont.systemFont(ofSize: 12),
                nonSelectedColor: UIColor = .black,
                selectionBackgroundColor: UIColor = .green,

                gradientColors: [UIColor] = [.lightGray, .white],
                gradientWidthInPercent: Double = 0.4,
                gradientPosition: GradientPosition = .below,
                
                itemWidth: Int = 100) {
        self.values = values
        self.defaultSelectedIndex = defaultSelectedIndex
        
        self.selectedFont = selectedFont
        self.selectedColor = selectedColor
        self.nonSelectedFont = nonSelectedFont
        self.nonSelectedColor = nonSelectedColor
        self.selectionBackgroundColor = selectionBackgroundColor
        
        self.gradientColors = gradientColors
        self.gradientWidthInPercent = gradientWidthInPercent
        self.gradientPosition = gradientPosition
        
        self.itemWidth = itemWidth
    }
}
