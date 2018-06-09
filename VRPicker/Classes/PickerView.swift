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

final class PickerView: UIView, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let cellModels: [PickerItemCollectionViewCell.Model]
    private let itemWidth: Int
    private let sliderVelocityCoefficient: Double
    private let defaultSelectedIndex: Int
    private var didSetDefault = false

    weak var delegate: PickerViewDelegate?

    private(set) var selectedIndex: Int = 0

    init(items: [String],
         itemWidth: Int,
         itemFont: UIFont,
         itemFontColor: UIColor,
         sliderVelocityCoefficient: Double,
         defaultSelectedIndex: Int) {
        self.cellModels = items.map {
            PickerItemCollectionViewCell.Model(text: $0, font: itemFont, fontColor: itemFontColor)
        }
        self.itemWidth = itemWidth
        self.sliderVelocityCoefficient = sliderVelocityCoefficient
        self.defaultSelectedIndex = defaultSelectedIndex

        super.init(frame: .zero)

        setupCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var xContentInset: CGFloat {
        return (frame.width - CGFloat(itemWidth)) / 2.0
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.itemSize = CGSize(width: self.itemWidth,
                                 height: self.itemWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(UINib(nibName: "PickerItemCollectionViewCell",
                                      bundle: Bundle(for: PickerView.self)),
                                forCellWithReuseIdentifier: "PickerItemCollectionViewCell")

        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false

        // TODO(vikrut): break apart this into a separate class
        // and things will probably become much more nicely separated
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    private lazy var singleTapGestureRecognizer = UITapGestureRecognizer.singleTap

    private func scroll(toIndex index: Int, animated: Bool = true) {
        let point = convert(indexToPoint: index)
        collectionView.setContentOffset(point, animated: animated)
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

        let itemIndex = Int(round(offsetX / CGFloat(itemWidth))).bound(minVal: 0, maxVal: cellModels.count - 1)

        return itemIndex
    }

    private func convert(indexToPoint index: Int) -> CGPoint {
        let itemX = CGFloat(itemWidth * index)
        return CGPoint(x: itemX - xContentInset, y: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.contentInset = UIEdgeInsets(top: 0, left: xContentInset,
                                                   bottom: 0, right: xContentInset)

        if !didSetDefault {
            set(selectedIndex: defaultSelectedIndex, animated: false)
            didSetDefault = true
        } else {
            set(selectedIndex: selectedIndex, animated: false)
        }
    }

    @objc private func scrollViewWasTapped(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: collectionView)

        let itemIndex = Int(floor(point.x / CGFloat(itemWidth))).bound(minVal: 0, maxVal: cellModels.count - 1)

        set(selectedIndex: itemIndex)
    }

    private func setupCollectionView() {
        addSubview(collectionView)

        collectionView.addGestureRecognizer(singleTapGestureRecognizer)
        singleTapGestureRecognizer.addTarget(self, action: #selector(scrollViewWasTapped(_:)))

        collectionView.matchSize(with: self)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PickerItemCollectionViewCell",
                                                      for: indexPath)

        if let cell = cell as? PickerItemCollectionViewCell {
            cell.update(model: cellModels[indexPath.row])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    internal func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                            withVelocity velocity: CGPoint,
                                            targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
