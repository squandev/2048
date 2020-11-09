//
//  FieldView.swift
//  2048
//
//  Created by Илья on 06.11.2020.
//

import UIKit


class FieldView: UIView {
    var fakeItems: [[FakeItem]] = []
    var items: [[ItemFieldView?]] = []
    let indentBetweenItems: CGFloat
    let itemSize: CGFloat

    required init?(coder: NSCoder) {
        fatalError ("NSCoding not supported")
    }
    
    init(frame: CGRect, indentBetweenItems: CGFloat, itemSize: CGFloat) {
        self.indentBetweenItems = indentBetweenItems
        self.itemSize = itemSize
        super.init(frame: frame)
        setupViews()
    }
    
    func createItem(point: ItemPoint, value: Int) {
        let frameFakeItem = fakeItems[point.x][point.y].frame
        let item = ItemFieldView(frame: frameFakeItem, value: value)
        item.transform = CGAffineTransform(scaleX: 0, y: 0)
        addSubview(item)
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            item.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        animator.startAnimation(afterDelay: 0.2)
        items[point.x][point.y] = item
    }
    
    func initialField(point: ItemPoint, value: Int) {
        guard value != 0 else {
            return
        }
        
        let frameFakeItem = fakeItems[point.x][point.y].frame
        let item = ItemFieldView(frame: frameFakeItem, value: value)
        addSubview(item)
        items[point.x][point.y] = item
    }
    
    func changeValue(oldPoint: ItemPoint, newPoint: ItemPoint, value: Int) {
        let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeIn) {
            self.items[oldPoint.x][oldPoint.y]!.frame = self.fakeItems[newPoint.x][newPoint.y].frame
        }
        animator.startAnimation()
        if let item = items[newPoint.x][newPoint.y] {
            item.isHidden = true
            item.removeFromSuperview()
        }
        items[newPoint.x][newPoint.y] = items[oldPoint.x][oldPoint.y]
        items[oldPoint.x][oldPoint.y] = nil
        items[newPoint.x][newPoint.y]!.point = value
    }
    
    private func setupViews() {
        createItems()
    }
    
    private func createItems() {
        var startPoint = CGPoint(x: indentBetweenItems, y: indentBetweenItems)
        for _ in 0...3 {
            var rowFake: [FakeItem] = []
            var rowNil: [ItemFieldView?] = []
            for _ in 0...3 {
                let item = FakeItem(frame: CGRect(origin: startPoint, size: CGSize(width: itemSize, height: itemSize)))
                item.backgroundColor = Color.defaultItem
                addSubview(item)
                rowFake.append(item)
                rowNil.append(nil)
                startPoint.x += itemSize + indentBetweenItems
            }
            startPoint.x = indentBetweenItems
            startPoint.y += itemSize + indentBetweenItems
            fakeItems.append(rowFake)
            items.append(rowNil)
        }
    }
}
