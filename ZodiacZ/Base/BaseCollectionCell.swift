//
//  BaseCollectionCell.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 3/20/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {

    var sign: Sign!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundView = UIView()
        addSubview(self.backgroundView!)
        self.backgroundView?.backgroundColor = SignDetailsVC.themeColor // .white
        self.backgroundView?.layer.cornerRadius = 20
        self.backgroundView?.fillSuperview()
//        self.backgroundView?.layer.shadowOpacity = 0.2
//        self.backgroundView?.layer.shadowRadius = 10
//        self.backgroundView?.layer.shadowOffset = .init(width: 0, height: 10)
//        self.backgroundView?.layer.shouldRasterize = true
//        self.backgroundView?.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            var transform: CGAffineTransform = .identity
            if isHighlighted {
                transform = .init(scaleX: 0.9, y: 0.9)
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = transform
            })
        }
    }
}
