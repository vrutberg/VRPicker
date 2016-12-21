//
//  VRSlider.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-17.
//

import Foundation
import UIKit

public protocol VRSliderDelegate: class {
    func slider(_ sender: VRSlider, didSelectIndex index: Int)
}

public class VRSlider: UIView {
    private let configuration: VRSliderConfiguration

    public weak var delegate: VRSliderDelegate?
    private var maskingLayer: CAShapeLayer?
    
    private(set) var selectedIndex = 0 {
        didSet {
            delegate?.slider(self, didSelectIndex: selectedIndex)
        }
    }

    public init(with configuration: VRSliderConfiguration, frame: CGRect) {
        self.configuration = configuration
        self.selectedIndex = configuration.defaultSelectedIndex
        
        super.init(frame: frame)

        layer.addSublayer(selectionColorLayer)
        setupGradientContainerView()
        setupPickerView()

        switch configuration.gradientPosition {
        case .above:
            bringSubview(toFront: gradientContainerView)

        case .below:
            bringSubview(toFront: pickerView)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO(vrutberg):
    // * this should probably be done in a fancier way...
    private func updateSubviews() {
        let gradientWidth = Int(Double(self.frame.width) * self.configuration.gradientWidthInPercent)
        
        leftGradientLayer.frame = CGRect(x: 0, y: 0, width: gradientWidth, height: Int(self.frame.height))
        rightGradientLayer.frame = CGRect(x: Int(self.frame.width) - gradientWidth, y: 0, width: gradientWidth, height: Int(self.frame.height))

        selectionColorLayer.frame = frame

        maskingLayer?.removeFromSuperlayer()
        maskingLayer = nil

        let newMaskingLayer = createMaskingLayer()
        layer.addSublayer(newMaskingLayer)
        maskingLayer = newMaskingLayer
    }

    private lazy var pickerView: PickerView = {
        let pickerView = PickerView(items: self.configuration.values, itemWidth: self.configuration.itemWidth, itemFont: self.configuration.nonSelectedFont)

        pickerView.translatesAutoresizingMaskIntoConstraints = false

        return pickerView
    }()

    private lazy var gradientContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var selectionColorLayer: CALayer = {
        let layer = CALayer()

        layer.backgroundColor = self.configuration.selectionColor.cgColor

        return layer
    }()

    private func createMaskingLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()

        let radius = CGFloat(self.configuration.itemWidth / 4)
        let y = (frame.height / CGFloat(2)) - radius
        let x = (frame.width / CGFloat(2)) - radius

        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), cornerRadius: 0)
        let circlePath = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true

        layer.path = path.cgPath
        layer.fillRule = kCAFillRuleEvenOdd
        layer.fillColor = backgroundColor?.cgColor

        return layer
    }

    private lazy var leftGradientLayer: CALayer = self.createGradientLayer(ofType: .left)
    private lazy var rightGradientLayer: CALayer = self.createGradientLayer(ofType: .right)
    
    private enum GradientLayerType {
        case left
        case right
    }
    
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
    
    func setupPickerView() {
        addSubview(pickerView)

        NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: pickerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: pickerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: pickerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
        
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        updateSubviews()
    }
    

    private func setupGradientContainerView() {
        gradientContainerView.layer.addSublayer(leftGradientLayer)
        gradientContainerView.layer.addSublayer(rightGradientLayer)

        addSubview(gradientContainerView)

        NSLayoutConstraint(item: gradientContainerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: gradientContainerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: gradientContainerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: gradientContainerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}


