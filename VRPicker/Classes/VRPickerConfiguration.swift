//
//  VRPickerConfiguration.swift
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

public protocol VRPickerItem: CustomStringConvertible {}

public struct VRPickerConfiguration<T: VRPickerItem> {
    let items: [T]
    let defaultSelectedIndex: Int

    let selectedFont: UIFont
    let selectedFontColor: UIColor
    let nonSelectedFont: UIFont
    let nonSelectedFontColor: UIColor

    let selectionRadiusInPercent: Double
    let selectionBackgroundColor: UIColor

    let gradientColors: [UIColor]
    let gradientWidthInPercent: Double
    let gradientPosition: GradientPosition

    let itemWidth: Int
    let sliderVelocityCoefficient: Double

    public init(items: [T],
                defaultSelectedIndex: Int = 0,

                selectedFont: UIFont = UIFont.boldSystemFont(ofSize: 20),
                selectedFontColor: UIColor = .white,
                nonSelectedFont: UIFont = UIFont.systemFont(ofSize: 14),
                nonSelectedFontColor: UIColor = .black,

                selectionRadiusInPercent: Double = 0.3,
                selectionBackgroundColor: UIColor = .green,

                gradientColors: [UIColor] = [UIColor.white.withAlphaComponent(0.8),
                                             UIColor.white.withAlphaComponent(0)],
                gradientWidthInPercent: Double = 0.4,
                gradientPosition: GradientPosition = .above,

                itemWidth: Int = 100,
                sliderVelocityCoefficient: Double = 60) {
        self.items = items
        self.defaultSelectedIndex = defaultSelectedIndex

        self.selectedFont = selectedFont
        self.selectedFontColor = selectedFontColor
        self.nonSelectedFont = nonSelectedFont
        self.nonSelectedFontColor = nonSelectedFontColor

        self.selectionRadiusInPercent = selectionRadiusInPercent
        self.selectionBackgroundColor = selectionBackgroundColor

        self.gradientColors = gradientColors
        self.gradientWidthInPercent = gradientWidthInPercent
        self.gradientPosition = gradientPosition

        self.itemWidth = itemWidth
        self.sliderVelocityCoefficient = sliderVelocityCoefficient
    }
}
