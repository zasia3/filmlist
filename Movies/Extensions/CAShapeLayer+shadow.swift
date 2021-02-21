//
//  CAShapeLayer+shadow.swift
//  Movies
//
//  Created by Joanna Zatorska on 20/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    func addRoundedShadow(bounds: CGRect, radius: CGFloat, offset: CGFloat = 2) {
        path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath.copy()
        addShadow(for: path)
    }
    
    func addShadow(for path: CGPath?, offset: CGFloat = 2) {
        fillColor = UIColor(named: "MainBackground")?.cgColor
        shadowColor = UIColor.black.cgColor
        shadowPath = path
        shadowOffset = CGSize(width: offset, height: offset)
        shadowOpacity = 0.3
        shadowRadius = offset
    }
}
