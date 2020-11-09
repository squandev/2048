//
//  CellFieldView.swift
//  2048
//
//  Created by Илья on 06.11.2020.
//

import UIKit

class ItemFieldView: UIView {
    
    var point: Int {
        get {
            return Int(count.text ?? "0")!
        }
        set {
            setupColor(newValue)
            count.text = String(newValue)
        }
    }
    
    private lazy var count: UILabel = {
        let count = UILabel()
        count.translatesAutoresizingMaskIntoConstraints = false
        count.adjustsFontSizeToFitWidth = true
        count.font = UIFont.systemFont(ofSize: 35, weight: .heavy)
        count.textAlignment = .center
        count.textColor = UIColor.white
//        count.font = UIFont(name: "Helvetica-Bold", size: self.frame.height * (2/3))
        return count
    }()
    
    required init?(coder: NSCoder) {
        fatalError ("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    convenience init(frame: CGRect, value: Int) {
        self.init(frame: frame)
        
        point = value
    }
    
    private func setupViews() {
        addSubview(count)
    }
    
    private func setupConstraints() {
        count.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        count.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
        count.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupColor(_ value: Int) {
        if value == 0 {
            backgroundColor = Color.defaultItem
        } else if value <= 8 {
            backgroundColor = Color.item8
            count.textColor = UIColor.black
        } else if value <= 32 {
            backgroundColor = Color.item32
        } else if value <= 128 {
            backgroundColor = Color.item128
        } else if value <= 256 {
            backgroundColor = Color.item256
        } else if value <= 512 {
            backgroundColor = Color.item512
        } else if value <= 1024 {
            backgroundColor = Color.item1024
        } else if value <= 2048 {
            backgroundColor = Color.item2048
        }
        
        if value > 8 {
            count.textColor = UIColor.white
        }
    }
}
