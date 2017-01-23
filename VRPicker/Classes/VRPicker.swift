//
//  VRPicker.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-17.
//

import Foundation
import UIKit

public protocol VRPickerDelegate: class {
    func picker<T>(_ sender: VRPicker, didSelect item: T)
}

public class VRPicker: UIView, PickerViewDelegate {
    private let configuration: VRPickerConfiguration

    public weak var delegate: VRPickerDelegate?

    private var maskingLayer: CAShapeLayer?
    private var circleLayer: CAShapeLayer?
    
    private(set) var selectedIndex = 0 {
        didSet {
            delegate?.picker(self, didSelect: configuration.items[selectedIndex])
        }
    }

    public init(with configuration: VRPickerConfiguration, frame: CGRect) {
        self.configuration = configuration
        self.selectedIndex = configuration.defaultSelectedIndex
        
        super.init(frame: frame)

        setupGradientContainerView()
        setupSelectionPickerView()
        setupPickerView()

        bringSubview(toFront: pickerView)

        switch configuration.gradientPosition {
        case .above:
            bringSubview(toFront: gradientContainerView)

        case .below:
            sendSubview(toBack: gradientContainerView)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateSubviews() {
        let gradientWidth = Int(Double(self.frame.width) * self.configuration.gradientWidthInPercent)
        
        leftGradientLayer.frame = CGRect(x: 0, y: 0, width: gradientWidth, height: Int(self.frame.height))
        rightGradientLayer.frame = CGRect(x: Int(self.frame.width) - gradientWidth, y: 0, width: gradientWidth, height: Int(self.frame.height))

        maskingLayer?.removeFromSuperlayer()
        maskingLayer = nil

        let newMaskingLayer = createMaskingLayer()
        selectionPickerView.layer.addSublayer(newMaskingLayer)
        maskingLayer = newMaskingLayer

        selectionPickerView.layer.mask = createCircleLayer()
        pickerView.layer.mask = createMaskingLayer()
    }

    private var itemsAsStrings: [String] {
        return configuration.items.map { $0.description }
    }

    private lazy var selectionPickerView: PickerView = {
        let pickerView = PickerView(items: self.itemsAsStrings, itemWidth: self.configuration.itemWidth, itemFont: self.configuration.selectedFont, itemFontColor: self.configuration.selectedFontColor, sliderVelocityCoefficient: self.configuration.sliderVelocityCoefficient)

        pickerView.translatesAutoresizingMaskIntoConstraints = false

        return pickerView
    }()

    private lazy var pickerView: PickerView = {
        let pickerView = PickerView(items: self.itemsAsStrings, itemWidth: self.configuration.itemWidth, itemFont: self.configuration.nonSelectedFont, itemFontColor: self.configuration.nonSelectedFontColor, sliderVelocityCoefficient: self.configuration.sliderVelocityCoefficient)

        pickerView.translatesAutoresizingMaskIntoConstraints = false

        return pickerView
    }()

    private lazy var gradientContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    private func createMaskingLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()

        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: 0)
        path.append(createCirclePath())
        path.usesEvenOddFillRule = true

        layer.path = path.cgPath
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = backgroundColor?.cgColor

        return layer
    }

    private func createCircleLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = createCirclePath().cgPath
        return layer
    }

    private func createCirclePath() -> UIBezierPath {
        let radius = CGFloat(Double(self.configuration.itemWidth) * configuration.selectionRadiusInPercent)
        let y = (frame.height / CGFloat(2)) - radius
        let x = (frame.width / CGFloat(2)) - radius

        return UIBezierPath(roundedRect: CGRect(x: x, y: y, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
    }

    private lazy var leftGradientLayer: CALayer = self.createGradientLayer(ofType: .left)
    private lazy var rightGradientLayer: CALayer = self.createGradientLayer(ofType: .right)

    
    private func createGradientLayer(ofType type: GradientLayerType) -> CAGradientLayer {
        let layer = CAGradientLayer()
        
        layer.frame = .zero
        
        switch type {
        case .left:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1.0, y: 0)

        case .right:
            layer.startPoint = CGPoint(x: 1.0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 0)
        }
        
        layer.colors = self.configuration.gradientColors.map { $0.cgColor }
        layer.locations = [0.0, 1.0]
        
        return layer
    }
    
    private func setupSelectionPickerView() {
        addSubview(selectionPickerView)
        selectionPickerView.layer.backgroundColor = UIColor.green.cgColor
        matchSizeWithConstraints(view1: selectionPickerView, view2: self)
    }

    private func setupPickerView() {
        addSubview(pickerView)
        pickerView.delegate = self
        matchSizeWithConstraints(view1: pickerView, view2: self)
    }
        
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateSubviews()
    }

    private func setupGradientContainerView() {
        gradientContainerView.layer.addSublayer(leftGradientLayer)
        gradientContainerView.layer.addSublayer(rightGradientLayer)

        addSubview(gradientContainerView)

        matchSizeWithConstraints(view1: gradientContainerView, view2: self)
    }

    // MARK: PickerViewDelegate

    func picker(_ sender: PickerView, didSlideTo: CGPoint) {
        selectionPickerView.scrollView.contentOffset.x = didSlideTo.x
    }

    func picker(_ sender: PickerView, didSelectIndex index: Int) {
        self.selectedIndex = index
    }

    private enum GradientLayerType {
        case left
        case right
    }
}
