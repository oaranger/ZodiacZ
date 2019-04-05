//
//  SignFullscreenDescriptionCell.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 3/21/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

class SignFullscreenDescriptionCell: UITableViewCell {
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share_button").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.layer.backgroundColor = #colorLiteral(red: 0.7090422144, green: 0.6409538497, blue: 0.9686274529, alpha: 1)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 2, left: 16, bottom: 2, right: 16)
        return button
    }()
    
    var sign: Sign! {
        didSet {
            let descriptionLabel: UILabel = {
                let label = UILabel()
                let attributedText = NSMutableAttributedString(string: sign.trait ?? "", attributes: [.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 16)])
                attributedText.append(NSAttributedString(string: (sign.trait == nil) ? sign.description : "\n\n" + sign.description, attributes: [.foregroundColor: UIColor.gray]))                
                label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
                label.attributedText = attributedText
                label.numberOfLines = 0
                return label
            }()
            
            let stackView = VerticalStackView(arrangedSubviews: [shareButton, descriptionLabel], spacing: 8)
            addSubview(stackView)
            stackView.alignment = .center
            
            shareButton.anchor(top: stackView.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 120, bottom: 12, right: 120), size: .init(width: 120, height: 40))
            stackView.fillSuperview(padding: .init(top: 0, left: 24, bottom: 0, right: 24))
        }
    }
}
