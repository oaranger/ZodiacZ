//
//  SignDetailsCell.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 3/20/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

class SignDetailsCell: BaseCollectionCell {
    
    override var sign: Sign! {
        didSet {
            titleLabel.text = sign.title
            imageView.image = UIImage(named: sign.image1)
            descriptionLabel.text = sign.trait ?? sign.description
        }
    }
    
    var topConstraint: NSLayoutConstraint!
    var stackView: VerticalStackView!
    let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 28), numberOfLines: 2)
    let imageView = UIImageView(image: #imageLiteral(resourceName: "libra"))
    let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        let imageContainerView = UIView()        
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 260, height: 320))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        stackView = VerticalStackView(arrangedSubviews: [
            titleLabel, imageContainerView, descriptionLabel
            ], spacing: 4)
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24))
        stackView.alignment = .center
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
