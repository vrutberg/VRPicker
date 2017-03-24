//
//  PickerView.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-21.
//
//

import Foundation
import UIKit

protocol PickerViewDelegate: class {
    func picker(_ sender: PickerView, didSelectIndex index: Int)
    func picker(_ sender: PickerView, didSlideTo: CGPoint)
}

final class PickerView: UIView, UIScrollViewDelegate {
    private let items: [String]
    private let itemWidth: Int
    private let itemFont: UIFont
    private let itemFontColor: UIColor
    private let sliderVelocityCoefficient: Double
    private let defaultSelectedIndex: Int
    private var didSetDefault = false

    var delegate: PickerViewDelegate?

    private(set) var selectedIndex: Int = 0

    init(items: [String],
         itemWidth: Int,
         itemFont: UIFont,
         itemFontColor: UIColor,
         sliderVelocityCoefficient: Double,
         defaultSelectedIndex: Int) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemFont = itemFont
        self.itemFontColor = itemFontColor
        self.sliderVelocityCoefficient = sliderVelocityCoefficient
        self.defaultSelectedIndex = defaultSelectedIndex

        super.init(frame: .zero)

        addSubview(scrollView)
        setupScrollView()
        setupScrollViewContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var xContentInset: CGFloat {
        return (frame.width - CGFloat(itemWidth)) / 2.0
    }

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: self.xContentInset, bottom: 0, right: self.xContentInset)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self

        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering

        return stackView
    }()

    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer()

        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.isEnabled = true
        gestureRecognizer.cancelsTouchesInView = false

        return gestureRecognizer
    }()

    private func scroll(toIndex index: Int, animated: Bool = true) {
        let point = convert(indexToPoint: index)
        scrollView.setContentOffset(point, animated: animated)
    }

    public func set(selectedIndex index: Int, animated: Bool = true) {
        scroll(toIndex: index, animated: animated)
        markItemAsSelected(at: index)
    }

    private func markItemAsSelected(at index: Int) {
        guard selectedIndex != index else {
            return
        }

        selectedIndex = index

        delegate?.picker(self, didSelectIndex: selectedIndex)
    }

    private func convert(contentOffsetToIndex contentOffset: CGFloat) -> Int {
        let offsetX = contentOffset + xContentInset

        var itemIndex = Int(round(offsetX / CGFloat(itemWidth)))

        if itemIndex > items.count - 1 {
            itemIndex = items.count - 1
        } else if itemIndex < 0 {
            itemIndex = 0
        }

        return itemIndex
    }

    private func convert(indexToPoint index: Int) -> CGPoint {
        let itemX = CGFloat(itemWidth * index)
        return CGPoint(x: itemX - xContentInset, y: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        scrollView.contentInset = UIEdgeInsets(top: 0, left: self.xContentInset, bottom: 0, right: self.xContentInset)

        if !didSetDefault {
            set(selectedIndex: defaultSelectedIndex, animated: false)
            didSetDefault = true
        } else {
            set(selectedIndex: selectedIndex, animated: false)
        }
    }

    @objc private func scrollViewWasTapped(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: scrollView)

        // TODO(vrutberg):
        // * This should probably be merged with convert(contentOffsetToIndex)
        var itemIndex = Int(floor(point.x / CGFloat(itemWidth)))

        if itemIndex > items.count - 1 {
            itemIndex = items.count - 1
        } else if itemIndex < 0 {
            itemIndex = 0
        }

        set(selectedIndex: itemIndex)
    }

    private func setupScrollView() {
        addSubview(scrollView)

        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        singleTapGestureRecognizer.addTarget(self, action: #selector(scrollViewWasTapped(_:)))

        matchSizeWithConstraints(view1: scrollView, view2: self)
    }

    private func setupScrollViewContent() {
        scrollView.addSubview(stackView)

        for value in items {
            let valueLabel = UILabel()
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.text = "\(value)"
            valueLabel.font = itemFont
            valueLabel.textColor = itemFontColor
            valueLabel.textAlignment = .center

            stackView.addArrangedSubview(valueLabel)

            NSLayoutConstraint(item: valueLabel, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0).isActive = true

            NSLayoutConstraint(item: valueLabel, attribute: .width, relatedBy: .equal, toItem: valueLabel, attribute: .height, multiplier: 1, constant: 0).isActive = true
        }

        matchSizeWithConstraints(view1: stackView, view2: scrollView)
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = scrollView.contentOffset.x + velocity.x * CGFloat(sliderVelocityCoefficient)
        let index = convert(contentOffsetToIndex: targetOffset)

        targetContentOffset.pointee = convert(indexToPoint: index)
    }

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = convert(contentOffsetToIndex: scrollView.contentOffset.x)

        delegate?.picker(self, didSlideTo: scrollView.contentOffset)

        markItemAsSelected(at: index)
    }
}
