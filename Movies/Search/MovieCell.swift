//
//  MovieCell.swift
//  Movies
//
//  Created by Joanna Zatorska on 17/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieCell"
    private weak var shadowLayer: CAShapeLayer?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = UIColor(named: "Hero")
        return label
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = UIColor(named: "Hero")
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    func configure() {
        let inset = CGFloat(10)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(yearLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        
        if shadowLayer == nil {
            let newLayer = CAShapeLayer()
            newLayer.addRoundedShadow(bounds: bounds, radius: 10)
            newLayer.fillColor = UIColor(named: "Background")?.cgColor
            layer.insertSublayer(newLayer, at: 0)
            shadowLayer = newLayer
        }
    }
}

