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
    let values: [Int]
    let defaultSelectedIndex: Int
    
    let selectedFont: UIFont
    let nonSelectedFont: UIFont
    let selectionColor: UIColor
    
    let gradientColors: [UIColor]
    let gradientWidthInPercent: Double
    let gradientPosition: GradientPosition
    
    let itemWidth: Int
    
    public init(values: [Int] = [1, 2, 3, 4, 5],
                defaultSelectedIndex: Int = 0,

                selectedFont: UIFont = UIFont.boldSystemFont(ofSize: 18),
                nonSelectedFont: UIFont = UIFont.systemFont(ofSize: 14),
                selectionColor: UIColor = .green,

                gradientColors: [UIColor] = [.lightGray, .white],
                gradientWidthInPercent: Double = 0.4,
                gradientPosition: GradientPosition = .below,
                
                itemWidth: Int = 100) {
        self.values = values
        self.defaultSelectedIndex = defaultSelectedIndex
        
        self.selectedFont = selectedFont
        self.nonSelectedFont = nonSelectedFont
        self.selectionColor = selectionColor
        
        self.gradientColors = gradientColors
        self.gradientWidthInPercent = gradientWidthInPercent
        self.gradientPosition = gradientPosition
        
        self.itemWidth = itemWidth
    }
}
