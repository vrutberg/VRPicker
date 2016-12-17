//
//  VRSlider.swift
//  Pods
//
//  Created by Viktor Rutberg on 2016-12-17.
//

import Foundation
import UIKit

public struct VRSliderConfiguration {
    let values: [Int]
    let defaultSelectedIndex: Int
    
    let sliderHeight: Int
    let sliderWidth: Int
    let itemWidth: Int
    
    public init(values: [Int], defaultSelectedIndex: Int, itemWidth: Int, sliderHeight: Int, sliderWidth: Int) {
        self.values = values
        self.defaultSelectedIndex = defaultSelectedIndex
        self.sliderHeight = sliderHeight
        self.sliderWidth = sliderWidth
        self.itemWidth = itemWidth
    }
}

public protocol VRSliderDelegate: class {
    func slider(_ sender: VRSlider, didSelectIndex index: Int)
}

public class VRSlider: UIView {
    
    public weak var delegate: VRSliderDelegate?
    
    internal let configuration: VRSliderConfiguration
    private(set) var selectedIndex: Int {
        didSet {
            delegate?.slider(self, didSelectIndex: selectedIndex)
        }
    }
    
    private let nonSelectedFont = UIFont.systemFont(ofSize: 14)
    private let selectedFont = UIFont.boldSystemFont(ofSize: 16)
    
    private var valueViews = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
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
    
    private lazy var leftGradientLayer: CALayer = {
        let layer = CAGradientLayer()
        
        let width = Int(Double(self.configuration.sliderWidth) * 0.4)
        
        layer.frame = CGRect(x: 0, y: 0, width: width, height: self.configuration.sliderHeight)
        
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1.0, y: 0)
        
        layer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        layer.locations = [0.0, 1.0]
        
        return layer
    }()
    
    private lazy var rightGradientLayer: CALayer = {
        let layer = CAGradientLayer()
        
        let width = Int(Double(self.configuration.sliderWidth) * 0.4)
        
        layer.frame = CGRect(x: self.configuration.sliderWidth - width, y: 0, width: width, height: self.configuration.sliderHeight)
        
        layer.startPoint = CGPoint(x: 1.0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 0)
        
        layer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        layer.locations = [0.0, 1.0]
        
        return layer
    }()
    
    private var didLayoutOnce = false
    
    internal var xContentInset: CGFloat {
        return CGFloat(configuration.sliderWidth - configuration.itemWidth) / 2.0
    }
    
    public init(configuration: VRSliderConfiguration) {
        self.configuration = configuration
        self.selectedIndex = configuration.defaultSelectedIndex
        
        super.init(frame: .zero)
        
        layer.addSublayer(leftGradientLayer)
        layer.addSublayer(rightGradientLayer)
        
        setupScrollView()
    }
    
    private func scroll(toIndex index: Int, animated: Bool = true) {
        let point = convert(indexToPoint: index)
        scrollView.setContentOffset(point, animated: animated)
    }
    
    public func set(selectedIndex index: Int, animated: Bool = true) {
        scroll(toIndex: index, animated: animated)
    }
    
    public func markItemAsSelected(at index: Int) {
        guard selectedIndex != index else {
            return
        }
        
        selectedIndex = index
        
        for (itemIndex, item) in stackView.arrangedSubviews.enumerated() {
            if itemIndex == index {
                (item as? UILabel)?.font = self.selectedFont
            } else {
                (item as? UILabel)?.font = self.nonSelectedFont
            }
        }
    }
    
    internal func convert(contentOffsetToIndex contentOffset: CGFloat) -> Int {
        let offsetX = contentOffset + self.xContentInset
        
        var itemIndex = Int(round(offsetX / CGFloat(self.configuration.itemWidth)))
        
        if itemIndex > self.configuration.values.count - 1 {
            itemIndex = self.configuration.values.count - 1
        } else if itemIndex < 0 {
            itemIndex = 0
        }
        
        return itemIndex
    }
    
    internal func convert(indexToPoint index: Int) -> CGPoint {
        let itemX = CGFloat(configuration.itemWidth * index)
        return CGPoint(x: itemX - xContentInset, y: 0)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if !didLayoutOnce {
            set(selectedIndex: self.selectedIndex, animated: false)
            didLayoutOnce = true
        }
    }
    
    @objc private func scrollViewWasTapped(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: scrollView)
        
        // TODO(vikrut):
        // * This should probably be merged with convert(contentOffsetToIndex)
        var itemIndex = Int(floor(point.x / CGFloat(self.configuration.itemWidth)))
        
        if itemIndex > self.configuration.values.count - 1 {
            itemIndex = self.configuration.values.count - 1
        } else if itemIndex < 0 {
            itemIndex = 0
        }
        
        set(selectedIndex: itemIndex)
    }
    
    private func setupScrollView() {
        self.addSubview(scrollView)
        
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
        singleTapGestureRecognizer.addTarget(self, action: #selector(self.scrollViewWasTapped(_:)))
        
        NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        setupScrollViewContent()
    }
    
    private func setupScrollViewContent() {
        scrollView.addSubview(stackView)
        
        for value in configuration.values {
            let valueLabel = UILabel()
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.text = "\(value)"
            valueLabel.font = nonSelectedFont
            valueLabel.textAlignment = .center
            
            stackView.addArrangedSubview(valueLabel)
            
            NSLayoutConstraint(item: valueLabel, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1, constant: 0).isActive = true
            
            NSLayoutConstraint(item: valueLabel, attribute: .width, relatedBy: .equal, toItem: valueLabel, attribute: .height, multiplier: 1, constant: 0).isActive = true
        }
        
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VRSlider: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = scrollView.contentOffset.x + velocity.x * 60.0
        let index = convert(contentOffsetToIndex: targetOffset)
        
        targetContentOffset.pointee = convert(indexToPoint: index)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = convert(contentOffsetToIndex: scrollView.contentOffset.x)
        
        markItemAsSelected(at: index)
    }
}
