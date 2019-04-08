//
//  SignFullscreenForecastDescriptionCell.swift
//  ZodiacZ
//
//  Created by Binh Huynh on 4/4/19.
//  Copyright © 2019 Binh Huynh. All rights reserved.
//

import UIKit

class SignFullscreenForecastDescriptionCell: UITableViewCell {
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "share_button").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.layer.backgroundColor = SignDetailsVC.themeColor.cgColor // #colorLiteral(red: 0.7090422144, green: 0.6409538497, blue: 0.9686274529, alpha: 1)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 2, left: 16, bottom: 2, right: 16)
        return button
    }()
    
    var forecastData: [String: Forecast]! {
        didSet {
            
            let descriptionLabel: UILabel = {
                let label = UILabel()
                var attributedText = NSMutableAttributedString(string: "\n")
                
                if let today = forecastData["today"], let date = today.date, let horoscope = today.horoscope {
                    attributedText.append(NSAttributedString(string: "Today (\(date))", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 20)]))
                    attributedText.append(NSAttributedString(string: "\n\n"))
                    attributedText.append(NSAttributedString(string: horoscope, attributes: [.foregroundColor: UIColor.white]))
                    attributedText.append(NSAttributedString(string: "\n\n"))
                }
                
                if let week = forecastData["week"], let date = week.week, let horoscope = week.horoscope {
                    attributedText.append(NSAttributedString(string: "This Week", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 20)]))
                    attributedText.append(NSAttributedString(string: "\n\n"))
                    attributedText.append(NSAttributedString(string: horoscope, attributes: [.foregroundColor: UIColor.white]))
                    attributedText.append(NSAttributedString(string: "\n\n"))
                }
                
                if let month = forecastData["month"], let date = month.month, let horoscope = month.horoscope {
                    attributedText.append(NSAttributedString(string: "This Month (\(date))", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 20)]))
                    attributedText.append(NSAttributedString(string: "\n\n"))
                    attributedText.append(NSAttributedString(string: horoscope, attributes: [.foregroundColor: UIColor.white]))
                    attributedText.append(NSAttributedString(string: "\n\n"))
                }

                if let year = forecastData["year"], let date = year.year, let horoscope = year.horoscope {
                    attributedText.append(NSAttributedString(string: "This Year (\(date))", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 20)]))
                    attributedText.append(NSAttributedString(string: "\n\n"))
                    attributedText.append(NSAttributedString(string: horoscope, attributes: [.foregroundColor: UIColor.white]))
                }                
  
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = SignDetailsVC.themeColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
