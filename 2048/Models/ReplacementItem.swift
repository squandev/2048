//
//  ItemPoint.swift
//  2048
//
//  Created by Илья on 06.11.2020.
//

import Foundation

struct ReplacementItem {
    let oldPoint: ItemPoint
    let newPoint: ItemPoint
    let value: Int
}

struct ItemPoint {
    var x: Int
    var y: Int
}
