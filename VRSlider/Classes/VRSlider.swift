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
        setupSelectionPickerView()
        setupPickerView2()

//        switch configuration.gradientPosition {
//        case .above:
//            bringSubview(toFront: gradientContainerView)

//        case .below:
            bringSubview(toFront: pickerView2)
//        }
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
        selectionPickerView.layer.addSublayer(newMaskingLayer)
        maskingLayer = newMaskingLayer
    }

    internal lazy var selectionPickerView: PickerView = {
        let pickerView = PickerView(items: self.configuration.values, itemWidth: self.configuration.itemWidth, itemFont: self.configuration.selectedFont, itemFontColor: self.configuration.selectedColor)

        pickerView.translatesAutoresizingMaskIntoConstraints = false

        return pickerView
    }()

    internal lazy var pickerView2: PickerView = {
        let pickerView = PickerView(items: self.configuration.values, itemWidth: self.configuration.itemWidth, itemFont: self.configuration.nonSelectedFont, itemFontColor: self.configuration.nonSelectedColor)

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

        layer.backgroundColor = self.configuration.selectionBackgroundColor.cgColor

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
    
    func setupSelectionPickerView() {
        addSubview(selectionPickerView)

        matchSizeWithConstraints(view1: selectionPickerView, view2: self)
    }

    func setupPickerView2() {
        addSubview(pickerView2)
        pickerView2.delegate = self
        matchSizeWithConstraints(view1: pickerView2, view2: self)
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

    private func matchSizeWithConstraints(view1: UIView, view2: UIView) {
        NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view2, attribute: .top, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: view1, attribute: .leading, relatedBy: .equal, toItem: view2, attribute: .leading, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: view1, attribute: .trailing, relatedBy: .equal, toItem: view2, attribute: .trailing, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view2, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
}

extension VRSlider: PickerViewDelegate {
    func slider(_ sender: PickerView, didSlideTo: CGPoint) {
        selectionPickerView.scrollView.contentOffset.x = didSlideTo.x
    }

    func slider(_ sender: PickerView, didSelectIndex index: Int) {

    }
}
