//
//  CellFieldView.swift
//  2048
//
//  Created by Илья on 06.11.2020.
//

import UIKit

class FakeItem: UIView {

    required init?(coder: NSCoder) {
        fatalError ("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

}
