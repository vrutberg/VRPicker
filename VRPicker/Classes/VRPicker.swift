//
//  VRPicker.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-17.
//

import Foundation
import UIKit

public class VRPicker<T: VRPickerItem>: UIControl, PickerViewDelegate {
    private let configuration: VRPickerConfiguration<T>

    private var maskingLayer: CAShapeLayer?
    private var circleLayer: CAShapeLayer?

    private(set) var selectedIndex: Int

    public var didSelectItem: (T) -> Void = { _ in }

    public init(with configuration: VRPickerConfiguration<T>, frame: CGRect) {
        self.configuration = configuration
        selectedIndex = configuration.defaultSelectedIndex

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
        let gradientWidth = Int(Double(frame.width) * configuration.gradientWidthInPercent)

        leftGradientLayer.frame = CGRect(x: 0, y: 0, width: gradientWidth, height: Int(frame.height))
        rightGradientLayer.frame = CGRect(x: Int(frame.width) - gradientWidth, y: 0,
                                          width: gradientWidth, height: Int(frame.height))
        
        maskingLayer?.removeFromSuperlayer()
        maskingLayer = nil

        let newMaskingLayer = createMaskingLayer()
        selectionPickerView.layer.addSublayer(newMaskingLayer)
        maskingLayer = newMaskingLayer

        selectionPickerView.layer.mask = createCircleLayer()
        pickerView.layer.mask = createMaskingLayer()
    }

    private lazy var selectionPickerView: PickerView = self.createPickerView(selection: true)
    private lazy var pickerView: PickerView = self.createPickerView(selection: false)

    private func createPickerView(selection: Bool) -> PickerView {
        let itemFont = selection ? configuration.selectedFont : configuration.nonSelectedFont
        let itemFontColor = selection ? configuration.selectedFontColor :  configuration.nonSelectedFontColor

        let pickerView = PickerView(items: configuration.itemsAsStrings,
                                    itemWidth: configuration.itemWidth,
                                    itemFont: itemFont,
                                    itemFontColor: itemFontColor,
                                    sliderVelocityCoefficient: configuration.sliderVelocityCoefficient,
                                    defaultSelectedIndex: configuration.defaultSelectedIndex)

        pickerView.translatesAutoresizingMaskIntoConstraints = false

        return pickerView
    }

    private lazy var gradientContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    private func createMaskingLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        let roundedRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        let path = UIBezierPath(roundedRect: roundedRect, cornerRadius: 0)
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
        let rectX = (frame.width / CGFloat(2)) - radius
        let rectY = (frame.height / CGFloat(2)) - radius

        let roundedRect = CGRect(x: rectX, y: rectY, width: 2 * radius, height: 2 * radius)

        return UIBezierPath(roundedRect: roundedRect, cornerRadius: radius)
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

        layer.colors = configuration.gradientColors.map { $0.cgColor }
        layer.locations = [0.0, 1.0]

        return layer
    }

    private func setupSelectionPickerView() {
        addSubview(selectionPickerView)

        selectionPickerView.layer.backgroundColor = configuration.selectionBackgroundColor.cgColor

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
        selectionPickerView.collectionView.contentOffset.x = didSlideTo.x
    }

    func picker(_ sender: PickerView, didSelectIndex index: Int) {
        selectedIndex = index
        didSelectItem(configuration.items[selectedIndex])
    }

    private enum GradientLayerType {
        case left
        case right
    }
}
