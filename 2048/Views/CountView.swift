//
//  CountView.swift
//  2048
//
//  Created by Илья on 08.11.2020.
//

import UIKit

class CountView: UIView {
    var labelName: UILabel = {
        let labelName = UILabel()
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        labelName.textColor = UIColor.white
        labelName.adjustsFontSizeToFitWidth = true
        labelName.textAlignment = .center
        return labelName
    }()
    
    var labelCount: UILabel = {
        let labelCount = UILabel()
        labelCount.translatesAutoresizingMaskIntoConstraints = false
        labelCount.textColor = UIColor.white
        labelCount.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        labelCount.textAlignment = .center
        labelCount.adjustsFontSizeToFitWidth = true
        return labelCount
    }()
    
    required init?(coder: NSCoder) {
        fatalError ("NSCoding not supported")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(labelName)
        addSubview(labelCount)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([labelName.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     labelName.topAnchor.constraint(equalTo: topAnchor, constant: 4),
                                     labelName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                                     labelName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)])
        
        NSLayoutConstraint.activate([labelCount.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     labelCount.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 4),
                                     labelCount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
                                     labelCount.widthAnchor.constraint(equalToConstant: 60)])
    }
}
